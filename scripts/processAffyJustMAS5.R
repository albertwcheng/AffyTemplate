setwd("../Data")

library(affy)
library(affydata)
library(vsn)



Data <- ReadAffy() #####

es3 = mas5(Data)

setwd("..")
dir.create("processed")
setwd("processed")


write.exprs(es3,file="mas5.txt")
print("MAS5 written")

save.image("Rdata.justMAS5")