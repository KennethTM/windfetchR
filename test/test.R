#test script to exercise functions in package
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
#Time difference of 4.621597 mins

#time using parallel processing
plan(multisession)

t0 <- Sys.time()
rast_large_multi_proc <- fetch(rast_large_islake, angle = seq(0, 360, 22.5))
t1 <- Sys.time()

print(t1-t0)
#Time difference of 2.565013 mins

#For small workloads the benefit of parallel processing is not as huge
#see the future and future.apply for more info on parallel processing



#plot for readme
rast_fetch_smooth_many <- fetch_smooth(rast_islake, angle = seq(0, by = 45, length.out=8), n = 2, interval = 2)

library(rasterVis)
theme <- rasterTheme(region = bpy.colors(20))
rasterVis::levelplot(rast_fetch_smooth_many, par.settings = theme)

