## 20190320: Ajustar tamanho dos circulos e a escala das legendas
# http://environmentalcomputing.net/making-maps-of-your-study-sites/
# wget(ftp://geoftp.ibge.gov.br/cartas_e_mapas/bases_cartograficas_continuas/bc250/versao2017/shapefile/Limites_v2017.zip)
# gunzip ./Limites_v2017.zip

library(sp)
library(rgeos)
library(rgdal)
library(ggplot2)
library(ggmap)
library(dplyr)
library(raster)

d <- read.csv("/home/arthurw/Documents/FitoPK/IlhasRio/Mapas/EspIndicadoras_IlhasRio_20180227_20181213_LatLong.csv", header=T, sep=',')


# Set geo Limits for the Coastal Rio de Janeiro and Cagarras Islands
geo_bounds <- c(left = -43.25, bottom = -23.1, right =-43.1, top = -22.92)
Sites.grid <- expand.grid(lon_bound = c(geo_bounds[1], geo_bounds[3]), 
                       lat_bound = c(geo_bounds[2], geo_bounds[4]))
                       
coordinates(Sites.grid) <- ~ lon_bound + lat_bound
IBGE <- readOGR(dsn = "lim_pais_a.shp")
IBGE_RJ <- crop(IBGE, extent(Sites.grid))

dS <- subset(d, Prof=="S")
dF <- subset(d, Prof=="F")


plotColeta <- function(Mapa, d){

g <- ggplot() +
 geom_polygon(data = Mapa, aes(x=long, y=lat, group=group), fill="gray85", colour="black") +
 coord_equal() +
 
 geom_point(data=d, aes(x=Long, y=Lat, size=sqrt(d$Enterococcus)), colour="blue", alpha=0.5, show.legend=TRUE) +
 #geom_text(data = legend_bubbles, size = 3, aes(x = -43.05, y = -23.05+ 2 * radius/50, label = label)) + Buscar fazer legenda com circulos concentricos
 #ggtitle(d$ColetaData[1]) +
 labs(x="Longitude", y="Latitude") +
 facet_wrap(~ColetaData)
 theme_classic()
 g
}





# Plot one map for each sampling date
for(i in unique(d$Prof)){
	print(i)
	count=0
	for(j in unique(d$Coleta)){
		svg(paste(i,j, "_Ecoli.svg", sep=''),8,6)
		print(j)
		rm(dd)
		dd <- subset(d, Prof==i & Coleta==j)
		plot(plotColeta(IBGE_RJ, dd))
		dev.off()
	}

}
