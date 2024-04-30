library(terra)
library(geodata)
ken <- gadm(country="KEN", level=1, path=".")
pol <- ken[ken$NAME_1 == "Marsabit", ]

iDir <- 'C:\\Users\\Lucy Kimani\\lucy\\Projects\\my_projects\\rprojects\\MODIS\\Data'
datadir <- file.path(iDir, "_modis")
mf <- file.path(datadir, "modis_cropped.tif")
rcrop <- rast(mf)

prj <- crs(rcrop)
prj
poly <- project(pol, prj)
poly
#Plot cropped MODIS and add the boundary
plotRGB(rcrop, r = 2, g = 1, b = 4, main='False color composite', stretch ="lin" )
lines(poly, col="blue")


#We expect the reflectance to be between 0 (very dark areas) and 1 (very bright areas). 
#clam values btn 0 and 1

r <- clamp(rcrop, 0, 1)
ndvi <- (r[[2]] - r[[1]]) /(r[[2]] + r[[1]])
plot(ndvi, main="NDVI")

#write a function to compute NDVI(optional)
nir_band <- r[[2]]
red_band <- r[[1]]

calculate_ndvi <- function(nir_band, red_band) {
  # Calculate NDVI using the formula
  ndvi <- (nir_band - red_band) / (nir_band + red_band)
  
  # Return the result
  return(ndvi)
}

# Calculate NDVI using the defined function
ndvi <- calculate_ndvi(nir_band, red_band)

# Plot NDVI
plot(ndvi, main="NDVI2")
