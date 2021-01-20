# Utility functions for fetch package

# Base function for calculating fetch from a direction
.fetch_base <- function(raster, angle){
  
  mat <- raster::as.matrix(raster)
  mat_col <- raster::ncol(mat)
  mat_row <- raster::nrow(mat)
  res <- raster::res(raster)[1]
  pad_size <- as.integer(sqrt((mat_col^2+mat_row^2))) + 4
  
  pad_list <- OpenImageR::padding(mat, new_rows = pad_size, new_cols = pad_size, fill_value = 0)
  
  mat_rotate <- OpenImageR::rotateImage(pad_list$data, angle, method = "nearest", mode = "same")
  
  mat_fetch <- fetch_base_cpp(mat_rotate, res)
  
  mat_inv_rotate <- OpenImageR::rotateImage(mat_fetch, (360-angle), method = "nearest", mode = "same")
  
  mat_crop <- mat_inv_rotate[(pad_list$padded_start+1):(nrow(mat_inv_rotate)-pad_list$padded_end), (pad_list$padded_left+1):(ncol(mat_inv_rotate)-pad_list$padded_right)]

  raster[] <- mat_crop
  raster[raster == 0] <- NA
  
  return(raster)
}

# Calculation of 'smoothed' from a direction
.fetch_base_smooth <- function(raster, angle, n = 3, interval = 3){
  
  minor_angles <- (0:(n*2))*interval
  minor_angles_mid <- median(minor_angles)
  angles <- (angle+(minor_angles-minor_angles_mid)) %% 360
  
  fetch_minor <- fetch(raster, angles)
  fetch_mean <- raster::calc(fetch_minor, mean, na.rm = TRUE)
  
  return(fetch_mean)
  
}
