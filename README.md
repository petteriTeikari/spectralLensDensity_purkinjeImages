# spectralLensDensity_purkinjeImages

Quick'n'dirty approximation of the error in spectral ocular media density estimation using Purkinje images as a function of the (virtual) `age` (as specified by the [van de Kraats and van Norren 2007]() ocular media model), half-bandwidth (`hbw`) and peak wavelength (`lambda_peak`) of the used light source(s).

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/error_landscape.png)_

_extreme example of the over-estimation of ocular media density at `age` = 88 years, and at `lambda_peak` = 405 nm with 6 different half-bandwidths of real commercial light emitters / interference filters. You can see that when using `hbw` = 3 nm interference filters, the error is quite negligible, whereas unfiltered "broadband" LED starts to introduces quite massive error. Positive deltaOD means that real-life SPD (spectral power distribution) overestimates ocular media density over "ideal SPD" with all the energy on single wavelength _

## How to use

Run [densityModel_sensitivityAnalysis_v2020.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/densityModel_sensitivityAnalysis_v2020.m)

### Just play with the plot

Run [density_error_plot.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/density_error_plot.m), and Matlab will import the pre-computed values from [plot_debug.ma](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/plot_debug.mat)

## Literature references

* Purkinje imaging for crystalline lens density measurement (2018), https://www.slideshare.net/PetteriTeikariPhD/purkinje-imaging-for-crystalline-lens-density-measurement
* Multispectral Purkinje Imaging (2018), https://www.slideshare.net/PetteriTeikariPhD/multispectral-purkinje-imaging
* Novel system for measuring the scattering of the cornea and the lens (2018) by Pau Santos Vives (PhD thesis from UPC, Barcelona), https://upcommons.upc.edu/handle/2117/121192
* System based on the contrast of Purkinje images to measure corneal and lens scattering by Pau Santos (2018), https://doi.org/10.1364/BOE.9.004907
* Optical quality of the eye lens surfaces from roughness and diffusion measurements (1986) by Rafael Navarro et al. https://doi.org/10.1364/JOSAA.3.000228
