setwd("../Data")

library(affy)
library(affydata)
library(vsn)
library(mouse4302mmensgcdf) #### hgu133plus2hsensgcdf



Data <- ReadAffy(cdfname="mouse4302mmensgcdf") #####

normalize.AffyBatch.methods <- c(normalize.AffyBatch.methods,"vsn")


es2 = justRMA(cdfname="mouse4302mmensgcdf") ####

setwd("..")
dir.create("processed")
setwd("processed")


write.exprs(es2,file="rma.mouse4302mmensgcdf.txt")
print("rma written")

es3 = mas5(Data)

write.exprs(es3,file="mas5.mouse4302mmensgcdf.txt")
print("mas5 written")

mas5Matrix=read.delim("mas5.hgu133plus2hsensgcdf.txt",row.names=1)
mas5.log2=log2(mas5Matrix)
write.table(cbind("ensID",t(as.matrix(colnames(mas5Matrix)))),"mas5log2.hgu133plus2hsensgcdf.txt",quote=FALSE,sep="\t",row.names=FALSE,col.names=FALSE)
write.table(mas5.log2,"mas5log2.hgu133plus2hsensgcdf.txt",quote=FALSE,sep="\t",append=TRUE,col.names=FALSE)


esMasCall = mas5calls(Data)

write.exprs(esMasCall,file="mas5calls.mouse4302mmensgcdf.txt")
print("mas5calls written")

es1 = expresso(Data,bg.correct=FALSE, normalize.method="vsn",pmcorrect.method="pmonly",summary.method="medianpolish")

write.exprs(es1,file="vsn.mouse4302mmensgcdf.txt")


save.image("Rdata.mouse4302mmensgcdf")