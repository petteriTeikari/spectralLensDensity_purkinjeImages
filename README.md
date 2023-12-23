# Measuring ocular media spectral transmittance using Purkinje Images

Some extra simulations for the paper **"A Purkinje image-based system for an assessment of the density and transmittance spectra of the human crystalline lens in vivo"** _Taisuke Eto, Petteri Teikari, Raymond P Najjar, Yuki Nishimura, Yuki Motomura, Manami Kuze, Shigekazu Higuchi Scientific Reports volume 10, Article number: 16445 (2020)_ https://doi.org/10.1038/s41598-020-73541-y

## Dependendence of measured ocular media density and light source spectral power distribution (SPD)

Quick'n'dirty approximation of the error in spectral ocular media density estimation using Purkinje images as a function of the (virtual) `age` (as specified by the [van de Kraats and van Norren 2007](https://doi.org/10.1364/JOSAA.24.001842) ocular media model, see [lensMediaWrapper.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/lensMediaWrapper.m) and [lensModel_vanDeKraats2007.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/lensModel_vanDeKraats2007.m) for code), half-bandwidth (`hbw`) and peak wavelength (`lambda_peak`) of the used light source(s).

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/error_landscape.png)

*extreme example of the over-estimation of ocular media density at `age` = 88 years, and at `lambda_peak` = 405 nm with 6 different half-bandwidths of real commercial light emitters / interference filters. You can see that when using `hbw` = 3 nm interference filters, the error is quite negligible, whereas unfiltered "broadband" LED starts to introduces quite massive error. Positive deltaOD means that real-life SPD (spectral power distribution) overestimates ocular media density over "ideal SPD" with all the energy on single wavelength.* 

*The "TO-Can Narrow linewidth Laser" should be quite close to the "ideal SPD" source, and the code needs some re-checking, as there is some "spectral round-off" error probably happening at light source generation part [monochromaticLightAsGaussian.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/monochromaticLightAsGaussian.m), the "ideal source" is not generated from the same code.*

### Light sources implemented

See the light sources in [lightSource_wrapper.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/lightSource_wrapper.m):
* `hbw` = 8.7500e-05 nm : TO-Can Narrow linewidth Laser - e.g. [Ondax 405 nm CP-405-PLR12](https://www.laserdiodesource.com/shop/405nm-15mW-TO-can-wavelength-stabilized-narrow-linewidth-Ondax)
* `hbw` = 2 nm : TO-Can Budget laser -  e.g. Sony OPTLD004, [Wavespectrum WSLD-405-150m-1](https://www.bbnint.co.uk/documents/data_sheets/Wavespectrum/WSLD-405-150m-1(5.6mm).pdf)
* `hbw` = 3 nm : 3 nm interference filter - e.g. Knight Optical 405 nm [405FIN2](https://www.knightoptical.com/stock/optical-components/uvvisnir-optics/filters/band-pass-filters/interference-bandpass-filters-narrowband-visible-range-405nm---710nm/405nm-bandpass-filter-25diax3nmbw-298606/), [BFI Optilas](http://52ebad10ee97eea25d5e-d7d40819259e7d3022d9ad53e3694148.r84.cf3.rackcdn.com/Interference_Filters_Guide_EN.pdf)
* `hbw` = 10 nm : 10 nm budget interference filter - e.g. EO 405 nm [#65-618](https://www.edmundoptics.co.uk/p/405nm-cwl-125mm-dia-10nm-fwhm-interference-filter/20136/), or UV LED without filter, e.g. [Luminus SST-10-UV](https://download.luminus.com/datasheets/Luminus_SST-10-UV_Datasheet.pdf)
* `hbw` = 15 nm : Narrow-peak LED - e.g. Kingbright 405 nm [ATDS3534UV405B](https://www.mouser.co.uk/datasheet/2/216/ATDS3534UV405B-1374630.pdf)
* `hbw` = 18 nm : Cheapest SMD LED (£0.464/pc) - % e.g. [Vishay VLMU3100-GS08](https://www.vishay.com/docs/82556/vlmu3100.pdf)  

### How to use

Run [densityModel_sensitivityAnalysis_v2020.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/densityModel_sensitivityAnalysis_v2020.m)

#### Just play with the error plot

Run [density_error_plot.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/density_error_plot.m), and Matlab will import the pre-computed values from [plot_debug.mat](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/plot_debug.mat)

##### Or just plot the ocular media density/transmittance

Run [plot_lens_density.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/plot_lens_density.m) that will give you this:

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/lensMedia.png)

*You see that if you are interested in designing your measurement system that you want to cover the short wavelength range with smaller wavelength increments as most of the density changes happen there, and in general your measurement comes noisier there. You can just throw couple of wavelengths above ~530 nm to constrain your model fit? The `offset` parameter in the [lensModel_vanDeKraats2007.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/082e4d34cef9532087c14e0387108ae38450156e/lensModel_vanDeKraats2007.m#L36) defines the spectrally neutral "global optical density", and default value of 0.111 was used for this in [lensMediaWrapper.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/082e4d34cef9532087c14e0387108ae38450156e/lensMediaWrapper.m#L20)*

## Illumination intensity compensation

Run [plot_compensated_lights.m](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/plot_compensated_lights.m) which will approximate how much you should boost short wavelengths even to detect the 4th Purkinje image on shorter wavelengths (See ["Illumination compensation
" in Wiki]([https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/wiki/Simulation-Literature-Review](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/wiki#illumination-compensation)) for rationale behind this plot). In other words account for the sensor spectral sensitivity and compensate for the 25 yr old lens template.

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/illuminationCorrection_on_lensDensity_and_CameraSensitivity.png)

_The 60 year old template lens should have as large as 2 log unit compensation if you would be using 400 nm peak wavelengths by simple transmittance attenuation analysis_

## Camera Sensor Bit Depth simulation

TODO! Simulate how does sensor bit depth affect your ability to compare lens density in practice. Is your 8-bit consumer camera sensor too quantized compared to 12/14/16-bit sensors? Could you do HDR in practice?

## LED Driver Dimming Bit Depth simulation

TODO! Similar to the effect of camera sensor bit depth. If you only have 8-bit PWM, you cannot do very nice intensity attenuation ratios, like you could do with better dimming ranges (e.g. [ISTL Quattro CC](https://www.ledsmagazine.com/company-newsfeed/article/16681974/ist-invents-led-and-oled-driver-with-worlds-widest-dimming-dynamic-range) or something that can use two DMX612 channels together for a 16-bit dimming range)


## Literature references

* **Purkinje imaging for crystalline lens density measurement** (2018), https://www.slideshare.net/PetteriTeikariPhD/purkinje-imaging-for-crystalline-lens-density-measurement
* **Multispectral Purkinje Imaging** (2018), https://www.slideshare.net/PetteriTeikariPhD/multispectral-purkinje-imaging
* **Novel system for measuring the scattering of the cornea and the lens** (2018) by Pau Santos Vives (PhD thesis from UPC, Barcelona), https://upcommons.upc.edu/handle/2117/121192
* **System based on the contrast of Purkinje images to measure corneal and lens scattering** by Pau Santos (2018), https://doi.org/10.1364/BOE.9.004907
* **Optical quality of the eye lens surfaces from roughness and diffusion measurements** (1986) by Rafael Navarro et al. https://doi.org/10.1364/JOSAA.3.000228

## TODO for more detailed simulation

**See the [Wiki](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/wiki) for more details**, and some background ophthalmic optics theory.

