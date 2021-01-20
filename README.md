# windfetchR

## R package for calculating wind fetch with rasters

This package provides function to calculate wind fetch, the unobstructed travel length of wind across a surface from a given direction, using rasters as implemented in the Raster package. 

Two methods for calculating fetch are available, a simple approach only considering the input angle and a 'smoothed' version, where the result is an average of minor angles given by a user defined number and interval.

The underlying function is implemented using Rcpp to speed up processing. The package support parallel processing using the future package.

### Installation

Use the 'remotes' package to install the package from Github:

```r
remotes::install_github('KennethTM/windfetchR')
```

### Examples of useage

The below examples exercise the function in the package:

```r
#load supplementary packages
library(sf)
library(raster)
library(windfetchR)

#get data
#we load a lake polygon and rasterize it
poly_path <- system.file("extdata", "lakepoly.sqlite", package = "windfetchR")
poly <- st_read(poly_path)

rast_tmp <- raster(poly, res = 5)

rast <- rasterize(as(poly, "Spatial"), rast_tmp, field = 1)

plot(rast)

#calculate fetch using one or more input angles
#(rast ==  1) is used to identify the water surface
rast_islake <- (rast ==  1)

rast_fetch_single <- fetch(rast_islake, angle = 45)
rast_fetch_many <- fetch(rast_islake, angle = seq(0, 360, 45))

#single angle yields a rasterlayer
plot(rast_fetch_single)

#multiple angles yields a rasterstack
plot(rast_fetch_many)

#calculate 'smoothed' fetch using one or more input angles
#in this case, fetch from 'n' angles spaced by 'interval' are added to each side of 'angle' and the final fetch an average of these
rast_fetch_smooth_single <- fetch_smooth(rast_islake, angle = 45, n = 2, interval = 2)
rast_fetch_smooth_many <- fetch_smooth(rast_islake, angle = seq(0, 360, 45), n = 2, interval = 2)

plot(rast_fetch_smooth_single)
plot(rast_fetch_smooth_many)

#windfetchR uses future.apply to allow the user to enable parallel processing
#this can speed up calculation of many angles or larges rasters
#to enable this, just call future:plan()

#create higher resolution raster and calculate fetch using both single and multi processing
rast_large <- disaggregate(rast, fact = 5)
rast_large_islake <- (rast_large ==  1)

#time using a single process
library(future)
plan(sequential)

t0 <- Sys.time()
rast_large_single_proc <- fetch(rast_large_islake, angle = seq(0, 360, 22.5))
t1 <- Sys.time()

print(t1-t0)
#Time difference of 4.6 mins

#time using parallel processing
plan(multisession)

t0 <- Sys.time()
rast_large_multi_proc <- fetch(rast_large_islake, angle = seq(0, 360, 22.5))
t1 <- Sys.time()

print(t1-t0)
#Time difference of 2.6 mins

#For small workloads the benefit of parallel processing is not as huge
#see the future and future.apply for more info on parallel processing
```

Example of output from fetch_smooth function:

![Example fetch raster](https://github.com/KennethTM/windfetchR/blob/main/test/example_img.png)
