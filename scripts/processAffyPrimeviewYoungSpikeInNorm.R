###Modified from Young Labs script

is.installed <- function(mypkg) is.element(mypkg, installed.packages()[,1])
if(!is.installed('primeviewercccdf')){
	install.packages("primeviewercccdf.tar.gz",repos=NULL)
}

library(affy)
library(primeviewercccdf)

#-------------

#Set the directory with the CEL files and the name of the rDump object you want produced

setwd("..")
setwd("Data")


#Get a list of CEL files from that directory, and load them
cel_files <- list.celfiles(path= ".",full.names=TRUE)
raw_data <- read.affybatch(cel_files, cdfname="primeviewercc")

#Process the raw CEL files through expresso. This is SIMILAR (but not exactly the same) as doing a MAS5 normalization. The settings are slightly different since we are using a custom CDF and it crashes otherwise. Could be improved
mas5Result <- expresso(raw_data,bgcorrect.method="mas",normalize=TRUE,pmcorrect.method="pmonly",summary.method="mas")

#Extract the matrix of MAS5 normalized expression values
all_mas5_exprs <- exprs(mas5Result)

all_mas5_exprs.log2=log2(all_mas5_exprs)

setwd("..")
dir.create("processed")
setwd("processed")


write.table(cbind("GeneName"=rownames(all_mas5_exprs),all_mas5_exprs), file="primeviewercccdf.mas5.txt", sep="\t", quote=FALSE, row.names=F)
write.table(cbind("GeneName"=rownames(all_mas5_exprs.log2),all_mas5_exprs.log2), file="primeviewercccdf.mas5Log2.txt", sep="\t", quote=FALSE, row.names=F)


#Use the loess.normalize command to re-normalize to the spike-in probes. This uses all probes annotated to ERCC's, and that includes a probeset to ERCC's not in the spike-in mix. But those should be zero and could serve as a negative control.
all_mas5_exprs_norm <- loess.normalize(all_mas5_exprs,subset=grep("ERCC-",rownames(all_mas5_exprs)))


all_mas5_exprs_norm.log2=log2(all_mas5_exprs_norm)

write.table(cbind("GeneName"=rownames(all_mas5_exprs_norm),all_mas5_exprs_norm), file="primeviewercccdf.mas5.spikeNorm.txt", sep="\t", quote=FALSE, row.names=F)
write.table(cbind("GeneName"=rownames(all_mas5_exprs_norm.log2),all_mas5_exprs_norm.log2), file="primeviewercccdf.mas5Log2.spikeNorm.txt", sep="\t", quote=FALSE, row.names=F)


#Write the result out
save(file= "primeviewercccdf.Norm.RData", all_mas5_exprs, all_mas5_exprs_norm, cel_files)
