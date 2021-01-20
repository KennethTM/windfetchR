#' Calculate wind fetch
#' 
#' Function to calculate wind fetch across a surface. Wind fetch is the unobstructed travel length of wind across a surface from a given direction. Input surfaces are supplied as logical (TRUE/FALSE) RasterLayer objects from the raster package and angles as numeric scalars or vectors.
#' When only one angle is supplied a RasterLayer is returned and a RasterStack otherwise.
#' 
#' Function uses future_lapply meaning that parallel processing can be enabled by calling future::plan(multisession) beforehand.
#'
#' @md
#' @param raster RasterLayer object.
#' @param angle RasterLayer object.
#' @return raster RasterLayer or RasterStack object.
#' @export fetch
#' @export
fetch <- function(raster, angle){
  
  if(!inherits(raster, "RasterLayer")){
    stop("Input mush a RasterLayer object from the raster package")
  }
  
  if(!(is.numeric(angle) & is.vector(angle))){
    stop("Input angles must be numeric and of type vector")
  }
  
  if(raster::dataType(raster) != "LOG1S"){
    stop("Input raster must be logical (e.g. TRUE/FALSE) where TRUE is the surface of interest")
  }
  
  if(any(angle < 0) | any(angle > 360)){
    stop("Input angles must be between 0 and 360 degrees")
  }
  
  n_angle <- length(angle)
  
  if(n_angle == 1){
    
    rast_out <- .fetch_base(raster, angle)
    
  }else{
    
    rast_out <- future.apply::future_lapply(angle, function(ang){.fetch_base(raster, ang)})
    rast_out <- raster::stack(rast_out)
    
  }
  
  names(rast_out) <- paste0("fetch_", as.character(angle), "_degrees")
    
  return(rast_out)
  
}

#' Calculate 'smoothed' wind fetch
#' 
#' Function to calculate wind fetch across a surface. Wind fetch is the unobstructed travel length of wind across a surface from a given direction. Input surfaces are supplied as logical (TRUE/FALSE) RasterLayer objects from the raster package and angles as numeric scalars or vectors.
#' When only one angle is supplied a RasterLayer is returned and a RasterStack otherwise.
#' 
#' Smoothed wind fetch is the fetch a given angle as an average of fetch from 'n' angles spaced by 'interval' degrees which are added to each side of 'angle'.
#' 
#' Function uses future_lapply meaning that parallel processing can be enabled by calling future::plan(multisession) beforehand.
#'
#' @md
#' @param raster RasterLayer object.
#' @param angle RasterLayer object.
#' @return raster RasterLayer or RasterStack object.
#' @export fetch
#' @export
fetch_smooth <- function(raster, angle, n = 3, interval = 3){
  
  if(!inherits(raster, "RasterLayer")){
    stop("Input mush a RasterLayer object from the raster package")
  }
  
  if(!(is.numeric(angle) & is.vector(angle))){
    stop("Input angles must be numeric and of type vector")
  }
  
  if(raster::dataType(raster) != "LOG1S"){
    stop("Input raster must be logical (e.g. TRUE/FALSE) where TRUE is the surface of interest")
  }
  
  if(any(angle < 0) | any(angle > 360)){
    stop("Input angles must be between 0 and 360 degrees")
  }
  
  n_angle <- length(angle)
  
  if(n_angle == 1){
    
    rast_out <- .fetch_base_smooth(raster, angle, n = n, interval = interval)
    
  }else{
    
    rast_out <- future.apply::future_lapply(angle, function(ang){.fetch_base_smooth(raster, ang, n = n, interval = interval)})
    rast_out <- raster::stack(rast_out)
    
  }
  
  names(rast_out) <- paste0("fetch_smooth_", as.character(angle), "_degrees")
  
  return(rast_out)
  
}
