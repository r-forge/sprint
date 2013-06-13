/**************************************************************************
 *                                                                        *
 *  SPRINT: Simple Parallel R INTerface                                   *
 *  Copyright © 2012 The University of Edinburgh                          *
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

#include "../../../sprint.h"
#include "../../common/utils.h"

int computeStringDist(int worldRank, int worldSize, char* DNAStringSet, int *stringDist, char *out_filename,
                   int sample_width, int number_of_samples, int my_start, int my_end, int chunk_size) {

  MPI_Status stat;
  MPI_File fh;
  int offset=0, count=0;
  int diss = my_end-my_start;

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
      stringDist[(c*number_of_samples)+j] = diff;
    }

    if(c==chunk_size) {

      MPI_File_write_at(fh, (my_start*number_of_samples)+(chunk_size*number_of_samples*count), stringDist, number_of_samples*chunk_size, MPI_INT, &stat);
      count++;
      c=0;
    }
    
  }

  MPI_File_write_at(fh, (my_start*number_of_samples)+(chunk_size*number_of_samples*count), stringDist, number_of_samples*c, MPI_INT, &stat);


  /* Close file handler */
  MPI_File_close(&fh);

  return 0;
}


int allocateMaxChunk(int worldRank, int my_start, int my_end, int *stringDist,
                     int number_of_samples) {

  int chunk_size = (my_end-my_start);
  int malloc_failed=1;
    
  if(NULL == (stringDist = (int *)malloc(sizeof(int)
                                              * number_of_samples * chunk_size)))
  {
  
    while(malloc_failed) {
      malloc_failed=0;
      chunk_size = chunk_size/2;
      
      stringDist = (int *)malloc(sizeof(int) * number_of_samples * chunk_size);
      
      if(stringDist == NULL) {
        malloc_failed=1;
      }

      free(stringDist);
    
    }

  }

  Rprintf("chunk_size: %d\n", chunk_size);

  return chunk_size;

}
