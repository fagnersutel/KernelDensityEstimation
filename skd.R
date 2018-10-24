#http://spatialanalysis.co.uk/2010/09/clipping-a-surface-by-a-polygon/

##R Spatial Data Tips: Clipping a Surface by a Polygon

##Background: A common function in standard GIS software enables users to 
##create a raster surface and extract values or clip it based on a set of polygons. 
##This may be used in cases where you want analysis to be constrained to within a town's 
##boundaries or a coastline. This tutorial will outline how to create a surface using 
##kernel density estimation (KDE) and then clip the surface so that it is constrained 
##within the City of London Boundary.

##Data Requirements:

##London Boundary Shapefile

##London Cycle Hire Locations

##Install the following packages:

##sm, maptools.

##Code (Comments are preceded by ##)

## Load packages

library(maptools)
library(sm)

##Set your working directory- this should be the folder where the above files are saved.

setwd("/Users/fsmoura/Downloads/Lond_City/")

## Load the cycle hire  locations.

cycle<- read.csv("London_cycle_hire_locs.csv", header=T)

## Inspect column headings

head(cycle)
dim(cycle)
## Plot the XY coordinates (do not close the plot window).

plot(cycle$X, cycle$Y)

##Load the City of London Boundary shapefile.

lon_city<- readShapePoly("lond_city.shp")

## Plot lon to see what it looks like in the context of cycle hire points.

plot(lon_city, add=T, lwd=2)

## Create a density surface based on the locations of the points. 
##This uses the sm.density function in the sm package.

cycle_dens<- sm.density(data.frame(cycle$X, cycle$Y), weights=cycle$Capacity, 
                        display= "image", ngrid=100)


## add the points and City of London boundary for context.

points(cycle$X, cycle$Y)
plot(lon_city, add=T, lwd=2)


## We can convert the cycle_dens output into a spatial grid for further spatial analysis. 

temp=SpatialPoints(expand.grid(x=cycle_dens$eval.points[,1], y=cycle_dens$eval.points[,2]))

temp = SpatialPixelsDataFrame(temp, data.frame(kde = array(cycle_dens$estimate, 
                                                           length(cycle_dens$estimate))))

## Now lets â???ocookie-cutâ??? the surface to only include the City of London.

sel=!is.na(over(temp, lon_city))

sel
clipped_grid= temp[sel,]
par(mfrow=c(1,1))

## Plot the final map.
image(clipped_grid)
plot(lon_city, add=T, lwd=2)
points(cycle$X, cycle$Y)
title("Density of London Cycle Hire Bikes in the City of London")

##Done!

##Acknowledgements:

##https://stat.ethz.ch/pipermail/r-sig-geo/2009-May/005793.html

##Further Reading:

##Applied spatial data analysis with R. Bivand et al.


##Disclaimer: The methods provided here may not be the best solutions, 
##just the ones I happen to know about! No support is provided with these worksheets. 
##I have tried to make them as self-explanatory as possible and will not be able to 
##respond to specific requests for help. I do however welcome feedback on the tutorials.
##License: cc-by-nc-sa. Contact: james@spatialanalysis.co.uk






library(spatstat) 
library(sp) 
library(maptools) 

city_shp <- readShapePoly("lond_city.shp") 
city_win <- as(as(city_shp, "SpatialPolygons"), "owin") 
city_win
bikedata <- read.csv("London_cycle_hire_locs.csv",header = TRUE) 
dim(bikedata)
attach(bikedata) 
names(bikedata) 
head(bikedata)
bikedata$Capacity = bikedata$Capacity*1000
bikes <- ppp(bikedata$X,bikedata$Y,c(min(bikedata$X), max(bikedata$X)), 
             c(min(bikedata$Y),max(bikedata$Y)),marks=bikedata$Capacity,window=city_win) 

k200 <- density.ppp(bikes, sigma =200,weights=bikes$Capacity,kernel = 
                      c("epanechnikov"), edge = TRUE, diggle=TRUE) 
summary(k200) 
options(scipen = 999)
plot(k200,col=heat.colors(256)) 
plot(city_win,add=TRUE,lwd=2) 
points(cycle$X, cycle$Y)

dados = dados[1:120,]

bikes <- ppp(dados$V1,dados$V2,c(min(dados$V1), max(dados$V1)), 
             c(min(dados$V2),max(dados$V2)),marks=dados$cluster,window=owin(c(-51.266,-51.04042),c(-30.24431, -29.96287))) 

k200 <- density.ppp(bikes, sigma =1600,weights=dados$cluster,kernel = 
                      c("epanechnikov"), edge = TRUE, diggle=TRUE) 
summary(k200) 
plot(k200,col=heat.colors(256)) 
plot(city_win,add=TRUE,lwd=2) 
points(dados$V1, dados$V2)

