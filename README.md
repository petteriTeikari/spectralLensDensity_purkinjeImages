# spectralLensDensity_purkinjeImages

Quick'n'dirty approximation of the error in spectral ocular media density estimation using Purkinje images as a function of the (virtual) `age` (as specified by the [van de Kraats and van Norren 2007](https://doi.org/10.1364/JOSAA.24.001842) ocular media model, see [lensMediaWrapper.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/lensMediaWrapper.m) and [lensModel_vanDeKraats2007.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/lensModel_vanDeKraats2007.m) for code), half-bandwidth (`hbw`) and peak wavelength (`lambda_peak`) of the used light source(s).

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/error_landscape.png)

*extreme example of the over-estimation of ocular media density at `age` = 88 years, and at `lambda_peak` = 405 nm with 6 different half-bandwidths of real commercial light emitters / interference filters. You can see that when using `hbw` = 3 nm interference filters, the error is quite negligible, whereas unfiltered "broadband" LED starts to introduces quite massive error. Positive deltaOD means that real-life SPD (spectral power distribution) overestimates ocular media density over "ideal SPD" with all the energy on single wavelength.* 

*The "TO-Can Narrow linewidth Laser" should be quite close to the "ideal SPD" source, and the code needs some re-checking, as there is some "spectral round-off" error probably happening at light source generation part [monochromaticLightAsGaussian.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/monochromaticLightAsGaussian.m), the "ideal source" is not generated from the same code.*

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

### Just play with the error plot

Run [density_error_plot.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/density_error_plot.m), and Matlab will import the pre-computed values from [plot_debug.mat](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/plot_debug.mat)

#### Or just plot the ocular media density/transmittance

Run [plot_lens_density.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/plot_lens_density.m) that will give you this:

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/lensMedia.png)

*You see that if you are interested in designing your measurement system that you want to cover the short wavelength range with smaller wavelength increments as most of the density changes happen there, and in general your measurement comes noisier there. You can just throw couple of wavelengths above ~530 nm to constrain your model fit?*

And if you would take out the crystalline lens from aged human eye (done during cataract surgery), the result would look something like this:

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/lensYellowing.png)

***(A)** Photograph of theLens Opacity Classification System (LOCS) III score chart used for assessing cataract severity [Chylack et al. 1993](http://doi.org/10.1001/archopht.1993.01090060119035), cited in [van den Berg 2018](https://doi.org/10.1111/opo.12426), **(B)**  Human crystalline lenses at different ages ([Cogan 1981](https://doi.org/10.1001/archopht.1981.03930010349032)), **(C)** Illustration how cataract not simply changes spectral transmittance, but also causes intraocular light scatter (from [Coastal Eye Care - Maine](https://www.facebook.com/CoastalEyeMaine/posts/june-is-cataract-awareness-month-a-cataract-is-the-cloudingyellowing-of-the-natu/1535847786551554/)*

If you are interested in using these to simulate how photoreception response (whatever your interest may be, e.g. circadian rhythms, pupillary light reflex, melatonin suppression, electroretinography, EEG, you name it), you can play with these artificial light sources for example (defined on 1 nm steps between 380 and 780 nm): https://github.com/petteriTeikari/lightLab/tree/master/database/LightSources/artificial. 

You can see the the "effective correlated color temperature (CCT)" changes quite drastically for older lenses, and one could question of using very high CCT light sources in elderly care homes for example if nothing really goes through the ocular media? Assuming that the elderly still have their natural crystalline lenses, and have not gone through a cataract surgery with a new intraocular lens (IOL)? 

And with the increasing popularity of violet-pumped white LEDs (e.g. [SORAA Bluefree/Zeroblue/Healthy](https://www.soraa.com/soraa-pro/technology/zeroblue.php), [Nichia Optisolis](https://www.nichia.co.jp/en/product/led_sp_optisolis.html), [YUJILEDS VTC range](https://www.yujiintl.com/tunable-spectrum.html), [Seoul SunLike](http://www.seoulsemicon.com/en/technology); and the attempt to [avoid 460 nm pumping (Leslie Lyons)](https://www.ledsmagazine.com/leds-ssl-design/article/14039534/is-it-time-to-say-goodbye-to-bluepump-leds-magazine)), and interesting question would be how colors are perceived and what are the nonvisual effects of such light sources through dense ocular media in elderly?

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/violetPumpedLEDs_and_ocularMedia.png)

## Literature references

* Purkinje imaging for crystalline lens density measurement (2018), https://www.slideshare.net/PetteriTeikariPhD/purkinje-imaging-for-crystalline-lens-density-measurement
* Multispectral Purkinje Imaging (2018), https://www.slideshare.net/PetteriTeikariPhD/multispectral-purkinje-imaging
* Novel system for measuring the scattering of the cornea and the lens (2018) by Pau Santos Vives (PhD thesis from UPC, Barcelona), https://upcommons.upc.edu/handle/2117/121192
* System based on the contrast of Purkinje images to measure corneal and lens scattering by Pau Santos (2018), https://doi.org/10.1364/BOE.9.004907
* Optical quality of the eye lens surfaces from roughness and diffusion measurements (1986) by Rafael Navarro et al. https://doi.org/10.1364/JOSAA.3.000228

## TODO!

### PSF of ocular media layers

It would be interesting to have some estimate of the **point-spread-function (PSF)** of the different surfaces, as remember that (from [Navarro et al. 1986](https://doi.org/10.1364/JOSAA.3.000228)):

*The **first and the fourth Purkinje images** can be considered **specular** images, whereas the **second and the third are diffuse**. The first image is specular because, in spite of the roughness of the corneal epithelium, the reflection takes place in the surface of the tear layer that covers the anterior surface of the cornea.* 

And from [Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192):

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/pauSantos2018_fresnelEquations_purkinjeImages.png)

Thus, qualitatively it is very hard to capture the 2nd and 3rd Purkinje Images, and when you remember where the reflections are coming (see below), realistically you can hope to capture the difference between the 1st and 4th Purkinje image (i.e. the ocular media density without knowing how much cornea and crystalline lens contribute). In practice this is all you want to know when wanting to know how to pre-filter your light stimulus to ensure that the retinal irradiance / photon flux is constant across your subjects (i.e. you want to study if there are [compensatory mechanisms with aging at "ocular"/retinal/(sub)cortical level](https://doi.org/10.1371/journal.pone.0085837) with age for non-image forming (NIF) photoreception)

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/purkinjeSchematics.png)

***(A)** Purkinje schematic modified from [Cavero et al. 2017](http://doi.org/10.1152/advan.00068.2017) showing the "impedance discontinuities" (if you are an electrical engineer) / refractive index discontinuities (optics) which cause the reflections that we call Purkinje(-Samson) images after Jan Evangelista Purkinje, **(B)** Locations of the Purkinje images assuming the Le Grand theoretical eye model and a distance of 500 mm between the object and the eye (x is taken from the corneal apex). The author also included some simulated optical layout on Zemax if you have a license and the skills for it ([Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192)), **(C)** Purkinje images (left) from healthy eye (top) with a cataract (middle) and eye with a corneal opacification (bottom), and the corresponding 3rd Purkinje Image (P3) and 4th Purkinje image (P4) intensity profiles (right). The values of P3 and P4 contrasts are also given ([Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192)).*

#### Zemax model with proper optomechanical alignment?

Might take some optimization to get nicely separated Purkinje Images (see below A for [Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192)'s analysis on the relation image size and object distance) with extra set of non-Purkinje reflection possibly occurring (see below B from [Mariana Quelhas Dias Rodrigues Almeida (2012)](https://www.semanticscholar.org/paper/Detection-of-purkinje-images-for-automatic-of-and-Almeida/9e9cf0d52edded3151898e21db6634d98a8b6f9b))

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/purkinjeImageSeparation.png)

***(A)** [Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192), **(B)** from [Mariana Quelhas Dias Rodrigues Almeida (2012)](https://www.semanticscholar.org/paper/Detection-of-purkinje-images-for-automatic-of-and-Almeida/9e9cf0d52edded3151898e21db6634d98a8b6f9b)*

### Camera Modeling

At the moment the camera's quantum efficiency is imported with no idea of the absolute irradiance / photon flux of the light source(s) used. You want your setup to comply to the standard [ISO 15004-2:2007 “Ophthalmic instruments -- Fundamental requirements and test methods - Part 2: Light hazard protection”](https://www.iso.org/standard/38952.html) to not cause hazard for the eyes of the subjects. This in turn means that you should calculate your absolute irradiances in any case, and then you could plug those values to your camera model and measure/estimate the effect of camera selection to your final ocular media density estimates?

[Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192) serves again as nice reference how to calculate the limit values for continuous-wave instruments (opposed to pulsed light source with high peak values):

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/safetyLimits.png)

_Table 3.2 of the ISO 15004-2:2007 “Limit values for continuous wave instruments”, Group 1 limit values for continuous wave instruments (Table 2, 5.4.1.4 of the ISO 15004-2:2007; Table 2, 5.4.1.6 of the ISO 15004-2:2007)_
