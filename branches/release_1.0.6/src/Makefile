# Ensure the following line is uncommented for debug logging
#_DEBUG = -D_DEBUG
#_PROF = -D_PROF

# Pull in the system specifics which the configuration script cooked up

include Makevars

MAKEFILE = Makefile

# * **************************************************************** *
# *  Each algorithm provided by the compute cluster is stored in a   *
# *  seperate directory. This allows shared resources, in the local  *
# *  root, and both interface and implementation code in eponimus    *
# *  directories.                                                    *
# * **************************************************************** *

SHLIB_OBJS = sprint.o

ALGORITHM_DIRS = algorithms/common algorithms/papply algorithms/pboot algorithms/pcor algorithms/pstringdistmatrix algorithms/pmaxT algorithms/ppam algorithms/prandomForest algorithms/pRP algorithms/ptest algorithms/rng  algorithms/psvm

INTERFACE_OBJS = algorithms/papply/interface/papply.o algorithms/pboot/interface/pboot.o algorithms/pcor/interface/pcor.o algorithms/pstringdistmatrix/interface/pstringDist.o algorithms/pmaxT/interface/pmaxT.o algorithms/ppam/interface/ppam.o algorithms/prandomForest/interface/random_forest.o algorithms/pRP/interface/boot-rp.o algorithms/pRP/interface/rp.o algorithms/ptest/interface/ptest.o algorithms/rng/interface/sprint-rng.o algorithms/psvm/interface/psvm.o

IMPLEMENTATION_OBJS = algorithms/papply/implementation/apply.o algorithms/papply/implementation/comms.o algorithms/papply/implementation/ffapply.o algorithms/papply/implementation/lapply.o algorithms/papply/implementation/main.o algorithms/pboot/implementation/boot.o algorithms/pcor/implementation/correlation.o algorithms/pcor/implementation/kernel.o algorithms/pstringdistmatrix/implementation/stringDist.o algorithms/pstringdistmatrix/implementation/stringDist_kernel.o algorithms/pmaxT/implementation/block_sampling_fixed.o algorithms/pmaxT/implementation/bootloop.o algorithms/pmaxT/implementation/mt.o algorithms/pmaxT/implementation/pairt_sampling.o algorithms/pmaxT/implementation/pairt_sampling_fixed.o algorithms/pmaxT/implementation/permutation.o algorithms/pmaxT/implementation/random.o algorithms/pmaxT/implementation/Rpack.o algorithms/pmaxT/implementation/sampling.o algorithms/pmaxT/implementation/sampling_fixed.o algorithms/pmaxT/implementation/stat_func.o algorithms/pmaxT/implementation/stat_order.o algorithms/ppam/implementation/bswap.o algorithms/ppam/implementation/cstat.o algorithms/ppam/implementation/pamedoids.o algorithms/ppam/implementation/silhouette.o algorithms/prandomForest/implementation/random_forest_driver.o algorithms/pRP/implementation/boot-rank-product.o algorithms/pRP/implementation/rank-product.o algorithms/pRP/implementation/rp-generic.o algorithms/ptest/implementation/test.o algorithms/rng/implementation/sprint-rng-worker.o algorithms/psvm/implementation/svm_call.o algorithms/psvm/implementation/Rsvm.o algorithms/psvm/implementation/svm.o

SHARED_ALGORITHM_OBJS = algorithms/common/functions.o algorithms/common/mmap.o algorithms/common/serialize.o algorithms/common/utils.o

OS = $(shell uname)
LONG_OS = $(shell uname -a)

# * **************************************************************** *
# *  Compiler flags additional to the ones R automatically provides  *
# * **************************************************************** *

LOCAL_CFLAGS = -pedantic -O3 -fPIC $(_DEBUG) $(_PROF)
CCFLAGS =  -O3 -fPIC
CFLAGS = -pedantic -O3 -fPIC 
CFLAGS_NO_OPT = -pedantic -fPIC $(_DEBUG) $(_PROF)
# The universal target

.PHONY: all
all: sprint.so

# * **************************************** *
# *  This is the library which links with R  *
# * **************************************** *

sprint.so: $(INTERFACE_OBJS) $(SHARED_ALGORITHM_OBJS) $(SHLIB_OBJS) $(IMPLEMENTATION_OBJS)
ifeq (Darwin,$(OS))
ifeq (mpicc,$(findstring mpicc,$(MPICC)))
	$(MPICC)  -dynamiclib -Wl,-headerpad_max_install_names -undefined dynamic_lookup  -o $@ $^ -Wl,-framework -Wl,CoreFoundation
else

endif
else

ifdef MPICXX
	$(MPICXX) -shared -o $@ $^
else
	$(CC) -shared -o $@ $^ $(MPILIBS)
endif
endif


%.o: %.cpp $(MAKEFILE)
	$(MPICXX) $(LOCAL_CFLAGS) -I$(R_INCLUDE_DIR) -c -o $@ $< 

%.o: %.c $(MAKEFILE)
	$(MPICC) $(LOCAL_CFLAGS) -I$(R_INCLUDE_DIR) -c -o $@ $< 

# * ****************************** *
# *  Clean up the build directory  *
# * ****************************** *

.PHONY: clean
clean:
	find . -name "*.o" -exec rm -f {} \;
	rm -f sprint.so
	rm -f Makevars

