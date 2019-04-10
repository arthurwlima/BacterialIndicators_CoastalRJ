# R CMD script to extract useful information from CTD castaway casts, discarding csv header
#!/usr/bin/Rscript

args <- commandArgs(TRUE)

# ponto, dataC, HoraC, Lat, Long, Prof_S, Prof_F, Prof_max, Temp_S, Temp_F, PSS_S, PSS_F
d <- read.table(args[1], header=F, sep=',', fill=T)
row.names(d) <- d[,1]

#ponto <- strsplit(strsplit(as.character(d[1,2]), "ponto")[[1]][2], "Ilhas")[[1]][1]
ponto <- 'NA'
dataC <- strsplit(as.character(d["% Cast time (local)",2]), " ")[[1]][1]
horaC <- strsplit(as.character(d["% Cast time (local)",2]), " ")[[1]][2]
dataC <- as.character(as.Date(dataC, format="%m/%d/%y"))
Lat <- as.character(d["% Start latitude", 2])
Long <- as.character(d["% Start longitude", 2])

dInicio <- match("Pressure (Decibar)", d[,1])
dd <- d[dInicio+1:length(d[,1]),]
dd <- subset(dd, is.na(dd[,1])==F)
tail(dd)

dd[,2] <- as.numeric(as.character(dd[,2]))
dd[,3] <- as.numeric(as.character(dd[,3]))
dd[,6] <- as.numeric(as.character(dd[,6]))
 
Prof_S <- mean(dd[,2][dd[,2]<4])
Temp_S <-  mean(dd[,3][dd[,2]<4])
PSS_S <- mean(dd[,6][dd[,2]<4])

Prof_max <- dd[length(dd[,2]),2] 
Prof_F <- mean(dd[,2][dd[,2] > I(max(dd[,2])-5)])
Temp_F <- mean(dd[,3][dd[,2] > I(max(dd[,2])-5)])
PSS_F <- mean(dd[,6][dd[,2] > I(max(dd[,2])-5)])


write.table(t(c(ponto, dataC, horaC, Lat, Long, Prof_S, Prof_F, Prof_max, Temp_S, Temp_F, PSS_S, PSS_F)), "CTD_summary_data_temp.csv", sep="\t", row.names=F, col.names=F, append=T, quote=F)

