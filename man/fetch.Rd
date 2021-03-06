% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fetch_functions.R
\name{fetch}
\alias{fetch}
\title{Calculate wind fetch}
\usage{
fetch(raster, angle)
}
\arguments{
\item{raster}{RasterLayer object.}

\item{angle}{RasterLayer object.}
}
\value{
raster RasterLayer or RasterStack object.
}
\description{
Function to calculate wind fetch across a surface. Wind fetch is the unobstructed travel length of wind across a surface from a given direction. Input surfaces are supplied as logical (TRUE/FALSE) RasterLayer objects from the raster package and angles as numeric scalars or vectors.
When only one angle is supplied a RasterLayer is returned and a RasterStack otherwise.
}
\details{
Function uses future_lapply meaning that parallel processing can be enabled by calling future::plan(multisession) beforehand.
}
