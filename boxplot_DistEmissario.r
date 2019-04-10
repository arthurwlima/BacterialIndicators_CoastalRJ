# R script for merging the bacterial abundance database and the table with 
# distance from the outlet to each of the sampling locations

dDist <- read.table("DistanciasKM.csv", header=T, sep=',')
d <- read.table("EspIndicadoras_IlhasRio_20180227_20181213.csv", header=T, sep=',')
> names(d)
[1] "Amostra"      "Ponto"        "Prof"         "ColetaData"   "Coleta"      
[6] "Enterococcus" "Ecoli"       
> names(dDist)
[1] "Ponto"              "Lat"                "Long"              
[4] "DistanciaEmissario" "DistanciaBaia"      "dEmisTriangulacao" 

d$Date <- as.Date(as.character(d$ColetaData), format="%Y%m%d")
dd <- merge(d, dDist, by="Ponto", all=T)

ddF <- subset(dd, Prof=="F")
ddS <- subset(dd, Prof=="S")
 
svg("Ecoli_F_DistP4.svg", 8,6)
boxplot(log10(ddF$Ecoli+1) ~ ddF$DistanciaEmissario, sub="Dist Emissario (km)", main="Fundo", ylab="Log10(Ecoli+1)", col=rgb(1,0,0, alpha=0.4))
axis(1, at=1:6, labels=c("P4", "Praia", "P3", "P2", "Rasa", "P1"),line=1.5, tick=F)
dev.off()
 
svg("Enterococcus_F_DistP4.svg", 8,6)
boxplot(log10(ddF$Enterococcus+1) ~ ddF$DistanciaEmissario,sub="Dist Emissario (km)", main="Fundo", ylab="Log10(Enterococcus+1)", col=rgb(0,0,1, alpha=0.4))
axis(1, at=1:6, labels=c("P4", "Praia", "P3", "P2", "Rasa", "P1"),line=1.5, tick=F)
dev.off()
 
 
svg("Ecoli_S_DistP4.svg", 8,6)
boxplot(log10(ddS$Ecoli+1) ~ ddS$DistanciaEmissario,sub="Dist Emissario (km)", main="Fundo", ylab="Log10(Ecoli+1)", col=rgb(1,0,0, alpha=0.4))
axis(1, at=1:6, labels=c("P4", "Praia", "P3", "P2", "Rasa", "P1"),line=1.5, tick=F)
dev.off()
 
svg("Enterococcus_S_DistP4.svg", 8,6)
boxplot(log10(ddS$Enterococcus+1) ~ ddS$DistanciaEmissario,sub="Dist Emissario (km)", main="Fundo", ylab="Log10(Enterococcus+1)", col=rgb(0,0,1, alpha=0.4))
axis(1, at=1:6, labels=c("P4", "Praia", "P3", "P2", "Rasa", "P1"),line=1.5, tick=F)
dev.off()
 
