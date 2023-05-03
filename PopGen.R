# Libraries ---------------------------------------------------------------
library(pegas)
library(adegenet)
library(vcfR)
library(ape)
library(hierfstat)
library(dplyr)

# Read Data ---------------------------------------------------------------
setwd("C:/Users/leserman/Documents/Rhodo_chapmanii/Subsample")
data <- read.vcfR("Rchap.passfilter.recode.vcf")
#data2 <- read.vcfR("Rchap.cohort.g.vcf") #Sites before filtering


# Convert to both genlight and genind -------------------------------------
x <- vcfR2genlight(data)
rchap <- vcfR2genind(data)


# Assign populations to individuals ---------------------------------------
#Pop assignments with 1=Hosford, 2=Gulf
pop(rchap) <- as.factor(c("1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "2", "2", "2", "2", "1", "1", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "1", "2", "2", "2", "2"))
pop(x) <- as.factor(c("1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "2", "2", "2", "2", "1", "1", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "1", "2", "2", "2", "2"))

#Pop assignments with 1=Extant Hosford, 2=Historical Hosford, 3=Historical Gulf, 4=Dove Field A, 5=Dove Field B, 6=Depot Creek, 7=Boundary Line, 8=NE Corner, 9=Dove Field C
#pop(x) <- as.factor(c("1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "2", "2", "2", "2", "2", "2", "2", "3", "3", "5", "4", "1", "1", "4", "5", "4", "4", "4", "4", "4", "5", "4", "5", "5", "4", "5", "5", "5", "5", "4", "4", "4", "4", "5", "4", "5", "4", "4", "4", "4", "5", "5", "5", "5", "5", "5", "5", "5", "5", "4", "4", "4", "5", "5", "5", "1", "4", "5", "5", "5"))
#pop(rchap) <- as.factor(c("1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "2", "2", "2", "2", "2", "2", "2", "3", "3", "5", "4", "1", "1", "4", "5", "4", "4", "4", "4", "4", "5", "4", "5", "5", "4", "5", "5", "5", "5", "4", "4", "4", "4", "5", "4", "5", "4", "4", "4", "4", "5", "5", "5", "5", "5", "5", "5", "5", "5", "4", "4", "4", "5", "5", "5", "1", "4", "5", "5", "5"))


# Calculate Fst, Ho, He, Fis ----------------------------------------------
fst <- basic.stats(rchap)
write.table(fst$Ho, file="Rchap_Ho.txt")
write.table(fst$Hs, file="Rchap_Hs.txt")
write.table(fst$Fis, file="Rchap_Fis.txt")
write.table(fst$overall, file="Rchap_all.txt")


# Inbreeding --------------------------------------------------------------
#Calculate Inbreeding
temp <- inbreeding(rchap)
Fbar <- sapply(temp, mean)
hist(Fbar, col="firebrick", main="Average inbreeding in R chapmanii")
which(Fbar>0.6)



# PCA ---------------------------------------------------------------------
pca1 <- glPca(x, nf=3)
scatter(pca1, posi="bottomright")

#plot PCA with 2 pop assignments
col <- funky(2)
#edit the xax and yax values if you want to visualize other PC axes
s.class(pca1$scores, pop(x), xax=1, yax=2, col=transp(col,.6), axesell=FALSE, cstar=0, cpoint=3, grid=FALSE)
add.scatter.eig(pca1$eig,2,1,2)

#Plot PCA with 9 pop assignments
#col <- funky(9)
#s.class(pca1$scores, pop(x), xax=1, yax=2, col=transp(col,.6), axesell=FALSE, cstar=0, cpoint=3, grid=FALSE)
#add.scatter.eig(pca1$eig,2,1,2)


# DAPC --------------------------------------------------------------------
grp <- find.clusters(rchap, max.n.clust=10)
dapc1 <- dapc(rchap, grp$grp)
scatter(dapc1)
