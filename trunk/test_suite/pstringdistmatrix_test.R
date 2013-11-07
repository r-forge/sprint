library("sprint")
library("Biostrings")
library("BSgenome.Celegans.UCSC.ce2")
library("ff")
detach("package:RUnit", unload=TRUE)
library("svUnit")

## Randomly extract 10000 40-mers from C.elegans chrI:
extractRandomReads <- function(subject, nread, readlength)
{
        if (!is.integer(readlength))
        readlength <- as.integer(readlength)
        start <- sample(length(subject) - readlength + 1L, nread,
                                        replace=TRUE)
        DNAStringSet(subject, start=start, width=readlength)
}

args <- commandArgs(trailingOnly = TRUE)
nreads <- as.numeric(args[1])
print("number of reads")

length <- as.numeric(args[2])
print("length")
print(length)

filename_ <- args[3]
print("filename")
print(filename_)

# Change this to test scaling.
rndreads <- extractRandomReads(Celegans$chrI, nreads, length)

stime_sprint <- proc.time()["elapsed"]
result <- pstringDist(rndreads, method="hamming", filename=filename_)
etime_sprint <- proc.time()["elapsed"]

print(paste("result: ")); print(paste(result))
print(paste("SPRINT pstringDist time: ")); print(paste(etime_sprint-stime_sprint))

print(system(paste("ls -lh|grep ",filename_)))
# system(paste("rm ",filename_))

