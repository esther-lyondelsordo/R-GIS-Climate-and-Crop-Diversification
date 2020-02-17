library(tidyverse)
library(raster)
library(rgdal)
library(rgeos)
library(ggplot2)
library(RColorBrewer)
library(viridis)
memory.limit(size=12000)
mat1 <- raster("wc2.0_bio_2.5m_01.tif")
mdr2 <- raster("wc2.0_bio_2.5m_02.tif")
iso3 <- raster("wc2.0_bio_2.5m_03.tif")
tsd4 <- raster("wc2.0_bio_2.5m_04.tif")
tmx5 <- raster("wc2.0_bio_2.5m_05.tif")
tmn6 <- raster("wc2.0_bio_2.5m_06.tif")
tar7 <- raster("wc2.0_bio_2.5m_07.tif")
twtq8 <- raster("wc2.0_bio_2.5m_08.tif")
tdrq9 <- raster("wc2.0_bio_2.5m_09.tif")
twrq10 <- raster("wc2.0_bio_2.5m_10.tif")
tcdq11 <- raster("wc2.0_bio_2.5m_11.tif")
map12 <- raster("wc2.0_bio_2.5m_12.tif")
pmx13 <- raster("wc2.0_bio_2.5m_13.tif")
pmn14 <- raster("wc2.0_bio_2.5m_14.tif")
psd15 <- raster("wc2.0_bio_2.5m_15.tif")
pwtq16 <- raster("wc2.0_bio_2.5m_16.tif")
pdrq17 <- raster("wc2.0_bio_2.5m_17.tif")
pwrq18 <- raster("wc2.0_bio_2.5m_18.tif")
pcdq19 <- raster("wc2.0_bio_2.5m_19.tif")

mtStack1 <- stack(mat1,mdr2,iso3,tsd4,tmx5,tmn6,tar7,twtq8,tdrq9,twrq10,
                 tcdq11,map12,pmx13,pmn14,psd15,pwtq16,pdrq17,pwrq18,
                 pcdq19)
mtStack1$tempSD <- mtStack1$wc2.0_bio_2.5m_04/10
#plot(mtStack1$wc2.0_bio_2.5m_04)

bounds1 <- readOGR(dsn=getwd(), layer= "TM_WORLD_BORDERS_SIMPL-0.3") 
#clipxy <- rbind(c(-125,-39),c(-125,75),c(50,-39),c(50,75))
#bounds <- crop(bounds1,clipxy)
#mtStack <- crop(mtStack1,clipxy)

#plot(mtStack$map_in, xlab="Longitude", ylab="Latitude")

b1 <-read.csv("Coordinates.csv")
pnts <- cbind(b1$Long,b1$Lat)

#breakpoints <- seq(0,250,length.out=11)
#col1 <- colorRampPalette(c('brown','yellow','blue'))
#color_levels=11

######################################################################
#### MAKE MAP ##########################################################
#tiff("AssocResistMap.tiff", width=8, height=6, units='in',
  #   res=600, compression='lzw')
#par(mfrow=c(1,1), mgp=c(3.5,1,0), mar=c(5.5,5.5,1,1), bg="black")
plot(mtStack1$tempSD, axes=F, xaxt='n',yaxt='n',
     col=rev(inferno(256)))
plot(bounds1, add=TRUE, col.axis="white")
#box(col="white", lwd=4)
#axis(1,col="white",col.axis="white",col.ticks="white", cex.axis=2, lwd=3, mgp=c(0,1,0),las=1)
#axis(2,col="white",col.axis="white",col.ticks="white", cex.axis=2, lwd=3, mgp=c(0,1,0),las=1)

points(pnts, pch=21, col="black", bg="green", cex=1.5, lwd=2)

#dev.off()

bioclims <- as.data.frame(extract(mtStack1, pnts), header=TRUE)

cabbage_sites <- cbind(b1,bioclims)
write.csv(cabbage_sites,"cabbage_sites.csv")

cabbage_sites <- read.csv("cabbage_sites.csv", header=T)

############################################################################
#####make ggplot figure
ggplot(data=cabbage_sites %>%filter(Herbivore_d>-10), aes(x=Lat, y=Herbivore_d))+
  geom_point()+geom_smooth(method = "lm")
ggplot(data=cabbage_sites, aes(x=tempSD, y=Enemy_d))+
  geom_point()+geom_smooth(method = "lm")
##mat
ggplot(data=cabbage_sites %>%filter(Herbivore_d>-10), aes(x=wc2.0_bio_2.5m_01, y=Herbivore_d))+
  geom_point()+geom_smooth(method = "lm")


