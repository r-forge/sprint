/**************************************************************************
 *                                                                        *
 *  SPRINT: Simple Parallel R INTerface                                   *
 *  Copyright © 2010 The University of Edinburgh                          *
 *                                                                        *
 *  This program is free software: you can redistribute it and/or modify  *
 *  it under the terms of the GNU General Public License as published by  *
 *  the Free Software Foundation, either version 3 of the License, or     *
 *  any later version.                                                    *
 *                                                                        *
 *  This program is distributed in the hope that it will be useful,       *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the          *
 *  GNU General Public License for more details.                          *
 *                                                                        *
 *  You should have received a copy of the GNU General Public License     *
 *  along with this program. If not, see <http://www.gnu.or/licenses/>.   *
 *                                                                        *
 **************************************************************************/
#include <R.h>
#include "../../../sprint.h"
#include "../../common/utils.h"

int hamming(int n, ...) {

  va_list ap; /*will point to each unnamed argument in turn*/
  int worldSize, worldRank, response;
  int sample_width, number_of_samples;
  char *DNAStringSet;
  int local_check=0, global_check=0;
  int my_start=0, my_end=0;

  int *hammingDistance;
  

  // Get size and rank from communicator
  MPI_Comm_size(MPI_COMM_WORLD, &worldSize);
  MPI_Comm_rank(MPI_COMM_WORLD, &worldRank);

  if (worldRank == 0) {
    if (n == 3) {
      
      // Get input variables
      va_start(ap,n);
      DNAStringSet = va_arg(ap,char*);
      sample_width = va_arg(ap,int);
      number_of_samples = va_arg(ap,int);
      va_end(ap);
    } else {
      DEBUG("rank 0 passed incorrect arguments into correlation!");
    }
    
    // Sent the dimensions to the slave processes
    MPI_Bcast(&sample_width, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&number_of_samples, 1, MPI_INT, 0, MPI_COMM_WORLD);
    
    // Sent the number of arguments
    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    
    // Master is always OK
    local_check = 0;
  } else {
    
    // Get the dimensions from the master
    MPI_Bcast(&sample_width, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&number_of_samples, 1, MPI_INT, 0, MPI_COMM_WORLD);
    DEBUG("Broadcasting width and length on %i. Got %i, %i\n", worldRank, sample_width, number_of_samples);
    
    // Get the number of arguments
    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    DEBUG("Broadcasting number of arguments on %i. Got %i\n", worldRank, n);
    
    // Allocate memory for the input data array
    DNAStringSet = (char *)malloc(sizeof(char) * sample_width * number_of_samples);
    
    // Check memory and make sure all slave processes have allocated successfully.
    // Perform an all-reduce operation to make sure everything is ok and then
    // move on to broadcast the data
    if ( DNAStringSet == NULL) {
      local_check = 1;
      ERR("**ERROR** : Input data array memory allocation failed on slave process %d. Aborting.\n", worldRank);
    }
    else {
      local_check = 0;
    }
  }

  MPI_Allreduce(&local_check, &global_check, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
  if ( global_check != 0 && worldRank != 0 ) {
    if ( DNAStringSet != NULL ) free(DNAStringSet);
    return -1;
  }
  else if ( global_check != 0 && worldRank == 0 )
    return -1;
  
  MPI_Bcast(DNAStringSet, number_of_samples*sample_width, MPI_CHAR, 0, MPI_COMM_WORLD);

  loopDistribute(worldRank, worldSize, number_of_samples, &my_start, &my_end);

  int malloc_failed=1;
//==============================

  int chunk_size = (my_end-my_start);
    
  if(NULL == (hammingDistance = (int *)malloc(sizeof(int)
                                              * number_of_samples * chunk_size)))
  {
  
    while(malloc_failed) {
      malloc_failed=0;
      chunk_size = chunk_size/2;
      
      hammingDistance = (int *)malloc(sizeof(int) * number_of_samples * chunk_size);
      
      if(hammingDistance == NULL) {
        malloc_failed=1;
      }

      free(hammingDistance);
    
    }

    hammingDistance = (int *)malloc(sizeof(int) * number_of_samples * chunk_size);
  }

  printf("rank-%d malloc exit at %d \n", worldRank, chunk_size);
//=============================
  
  DEBUG("loopDistribute results on %i, %i %i\n", worldRank, my_start, my_end);    
  DEBUG("Running hamming kernel on %i\n", worldRank);
  
  response = computeHamming(worldRank, worldSize, DNAStringSet, hammingDistance,
                            sample_width, number_of_samples, my_start, my_end, chunk_size);

  DEBUG("Done running hamming kernel on %i\n", worldRank);
 
  if ( worldRank != 0 ) {
    
    free(DNAStringSet);
  }
  
  return;
}

int computeHamming(int worldRank, int worldSize, char* DNAStringSet, int *hammingDistance,
                   int sample_width, int number_of_samples, int my_start, int my_end, int chunk_size) {

  MPI_Status stat;
  MPI_File fh;
  int offset=0, count=0;
  char *out_filename;
  int diss = my_end-my_start;

  out_filename = "result.dat";

  int i,j,k,c,diff;

  /* Open the file handler */
  MPI_File_open(MPI_COMM_WORLD, out_filename, MPI_MODE_CREATE | MPI_MODE_WRONLY, MPI_INFO_NULL, &fh);

  /* The MPI_FILE_SET_VIEW routine changes the process's view of the data in the file */
  MPI_File_set_view(fh, 0, MPI_INT, MPI_INT, "native", MPI_INFO_NULL);
  
  for (i=my_start,c=0; i<my_end; i++,c++) {
    for(j=0; j<number_of_samples; j++) {

      diff = 0;
      for(k=0; k<sample_width; k++) {
        
        if(DNAStringSet[i*sample_width+k] != DNAStringSet[j*sample_width+k])
          diff++;

      }
      hammingDistance[(c*number_of_samples)+j] = diff;
    }
//    printf("rank-%d i:%d offset: %d\n", worldRank, i,  my_start+c*number_of_samples);

    if(c==chunk_size) {

      printf("rank-%d mystart:%d myend:%d c:%d\n", worldRank, my_start, my_end, c);
      
      printf("rank-%d offset:%d count:%d\n", worldRank, (my_start*number_of_samples)+(chunk_size*number_of_samples*count), number_of_samples*chunk_size);
      MPI_File_write_at(fh, (my_start*number_of_samples)+(chunk_size*number_of_samples*count), hammingDistance, number_of_samples*chunk_size, MPI_INT, &stat);
      count++;
      c=0;
    }
    
//    MPI_File_write_at(fh, (my_start+c)*number_of_samples, hammingDistance, number_of_samples, MPI_INT, &stat);
  }

  printf("rank-%d offset:%d count:%d\n", worldRank, (my_start*number_of_samples)+(chunk_size*number_of_samples*count), number_of_samples*c);
  
  MPI_File_write_at(fh, (my_start*number_of_samples)+(chunk_size*number_of_samples*count), hammingDistance, number_of_samples*c, MPI_INT, &stat);


  /* Close file handler */
  MPI_File_close(&fh);

  return 0;
}


