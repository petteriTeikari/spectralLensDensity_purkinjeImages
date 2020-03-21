# spectralLensDensity_purkinjeImages

Quick'n'dirty approximation of the error in spectral ocular media density estimation using Purkinje images as a function of the (virtual) `age` (as specified by the [van de Kraats and van Norren 2007](https://doi.org/10.1364/JOSAA.24.001842) ocular media model, see [lensMediaWrapper.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/lensMediaWrapper.m) and [lensModel_vanDeKraats2007.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/lensModel_vanDeKraats2007.m) for code), half-bandwidth (`hbw`) and peak wavelength (`lambda_peak`) of the used light source(s).

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/error_landscape.png)

*extreme example of the over-estimation of ocular media density at `age` = 88 years, and at `lambda_peak` = 405 nm with 6 different half-bandwidths of real commercial light emitters / interference filters. You can see that when using `hbw` = 3 nm interference filters, the error is quite negligible, whereas unfiltered "broadband" LED starts to introduces quite massive error. Positive deltaOD means that real-life SPD (spectral power distribution) overestimates ocular media density over "ideal SPD" with all the energy on single wavelength*

## Light sources

See the light sources in [lightSource_wrapper.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/lightSource_wrapper.m):
* 8.7500e-05 nm : TO-Can Narrow linewidth Laser - e.g. [Ondax 405 nm CP-405-PLR12](https://www.laserdiodesource.com/shop/405nm-15mW-TO-can-wavelength-stabilized-narrow-linewidth-Ondax)
* 2 nm : TO-Can Budget laser -  e.g. Sony OPTLD004, [Wavespectrum WSLD-405-150m-1](https://www.bbnint.co.uk/documents/data_sheets/Wavespectrum/WSLD-405-150m-1(5.6mm).pdf)
* 3 nm : 3 nm interference filter - e.g. Knight Optical 405 nm [405FIN2](https://www.knightoptical.com/stock/optical-components/uvvisnir-optics/filters/band-pass-filters/interference-bandpass-filters-narrowband-visible-range-405nm---710nm/405nm-bandpass-filter-25diax3nmbw-298606/), [BFI Optilas](http://52ebad10ee97eea25d5e-d7d40819259e7d3022d9ad53e3694148.r84.cf3.rackcdn.com/Interference_Filters_Guide_EN.pdf)
* 10 nm : 10 nm budget interference filter - e.g. EO 405 nm [#65-618](https://www.edmundoptics.co.uk/p/405nm-cwl-125mm-dia-10nm-fwhm-interference-filter/20136/), or UV LED without filter, e.g. [Luminus SST-10-UV](https://download.luminus.com/datasheets/Luminus_SST-10-UV_Datasheet.pdf)
* 15 nm : Narrow-peak LED - e.g. Kingbright 405 nm [ATDS3534UV405B](https://www.mouser.co.uk/datasheet/2/216/ATDS3534UV405B-1374630.pdf)
* 18 nm : Cheapest SMD LED (£0.464/pc) - % e.g. [Vishay VLMU3100-GS08](https://www.vishay.com/docs/82556/vlmu3100.pdf)  

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
