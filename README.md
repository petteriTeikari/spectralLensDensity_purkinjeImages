# Measuring ocular media spectral transmittance using Purkinje Images

Quick'n'dirty approximation of the error in spectral ocular media density estimation using Purkinje images as a function of the (virtual) `age` (as specified by the [van de Kraats and van Norren 2007](https://doi.org/10.1364/JOSAA.24.001842) ocular media model, see [lensMediaWrapper.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/lensMediaWrapper.m) and [lensModel_vanDeKraats2007.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/lensModel_vanDeKraats2007.m) for code), half-bandwidth (`hbw`) and peak wavelength (`lambda_peak`) of the used light source(s).

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/error_landscape.png)

*extreme example of the over-estimation of ocular media density at `age` = 88 years, and at `lambda_peak` = 405 nm with 6 different half-bandwidths of real commercial light emitters / interference filters. You can see that when using `hbw` = 3 nm interference filters, the error is quite negligible, whereas unfiltered "broadband" LED starts to introduces quite massive error. Positive deltaOD means that real-life SPD (spectral power distribution) overestimates ocular media density over "ideal SPD" with all the energy on single wavelength.* 

*The "TO-Can Narrow linewidth Laser" should be quite close to the "ideal SPD" source, and the code needs some re-checking, as there is some "spectral round-off" error probably happening at light source generation part [monochromaticLightAsGaussian.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/monochromaticLightAsGaussian.m), the "ideal source" is not generated from the same code.*

## Light sources

See the light sources in [lightSource_wrapper.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/lightSource_wrapper.m):
* `hbw` = 8.7500e-05 nm : TO-Can Narrow linewidth Laser - e.g. [Ondax 405 nm CP-405-PLR12](https://www.laserdiodesource.com/shop/405nm-15mW-TO-can-wavelength-stabilized-narrow-linewidth-Ondax)
* `hbw` = 2 nm : TO-Can Budget laser -  e.g. Sony OPTLD004, [Wavespectrum WSLD-405-150m-1](https://www.bbnint.co.uk/documents/data_sheets/Wavespectrum/WSLD-405-150m-1(5.6mm).pdf)
* `hbw` = 3 nm : 3 nm interference filter - e.g. Knight Optical 405 nm [405FIN2](https://www.knightoptical.com/stock/optical-components/uvvisnir-optics/filters/band-pass-filters/interference-bandpass-filters-narrowband-visible-range-405nm---710nm/405nm-bandpass-filter-25diax3nmbw-298606/), [BFI Optilas](http://52ebad10ee97eea25d5e-d7d40819259e7d3022d9ad53e3694148.r84.cf3.rackcdn.com/Interference_Filters_Guide_EN.pdf)
* `hbw` = 10 nm : 10 nm budget interference filter - e.g. EO 405 nm [#65-618](https://www.edmundoptics.co.uk/p/405nm-cwl-125mm-dia-10nm-fwhm-interference-filter/20136/), or UV LED without filter, e.g. [Luminus SST-10-UV](https://download.luminus.com/datasheets/Luminus_SST-10-UV_Datasheet.pdf)
* `hbw` = 15 nm : Narrow-peak LED - e.g. Kingbright 405 nm [ATDS3534UV405B](https://www.mouser.co.uk/datasheet/2/216/ATDS3534UV405B-1374630.pdf)
* `hbw` = 18 nm : Cheapest SMD LED (£0.464/pc) - % e.g. [Vishay VLMU3100-GS08](https://www.vishay.com/docs/82556/vlmu3100.pdf)  

## How to use

Run [densityModel_sensitivityAnalysis_v2020.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/densityModel_sensitivityAnalysis_v2020.m)

### Just play with the error plot

Run [density_error_plot.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/density_error_plot.m), and Matlab will import the pre-computed values from [plot_debug.mat](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/plot_debug.mat)

#### Or just plot the ocular media density/transmittance

Run [plot_lens_density.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/master/plot_lens_density.m) that will give you this:

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/lensMedia.png)

*You see that if you are interested in designing your measurement system that you want to cover the short wavelength range with smaller wavelength increments as most of the density changes happen there, and in general your measurement comes noisier there. You can just throw couple of wavelengths above ~530 nm to constrain your model fit? The `offset` parameter in the [lensModel_vanDeKraats2007.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/082e4d34cef9532087c14e0387108ae38450156e/lensModel_vanDeKraats2007.m#L36) defines the spectrally neutral "global optical density", and default value of 0.111 was used for this in [lensMediaWrapper.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/082e4d34cef9532087c14e0387108ae38450156e/lensMediaWrapper.m#L20)*

##### Yellowed ocular media in practice

And if you would take out the crystalline lens from aged human eye (done during cataract surgery), the result would look something like this:

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/lensYellowing.png)

***(A)** Photograph of theLens Opacity Classification System (LOCS) III score chart used for assessing cataract severity [Chylack et al. 1993](http://doi.org/10.1001/archopht.1993.01090060119035), cited in [van den Berg 2018](https://doi.org/10.1111/opo.12426), **(B)**  Human crystalline lenses at different ages ([Cogan 1981](https://doi.org/10.1001/archopht.1981.03930010349032)), **(C)** Illustration how cataract not simply changes spectral transmittance, but also causes intraocular light scatter (from [Coastal Eye Care - Maine](https://www.facebook.com/CoastalEyeMaine/posts/june-is-cataract-awareness-month-a-cataract-is-the-cloudingyellowing-of-the-natu/1535847786551554/))*

If you are interested in using these to simulate how photoreception response (whatever your interest may be, e.g. circadian rhythms, pupillary light reflex, melatonin suppression, electroretinography, EEG, you name it), you can play with these artificial light sources tabulated in csv files defined on 1 nm steps between 380 and 780 nm): https://github.com/petteriTeikari/lightLab/tree/master/database/LightSources/artificial. 

You can see the the "effective correlated color temperature (CCT)" changes quite drastically for older lenses, and one could question of using very high CCT light sources in elderly care homes for example if nothing really goes through the ocular media? Assuming that the elderly still have their natural crystalline lenses, and have not gone through a cataract surgery with a new intraocular lens (IOL)? 

And with the increasing popularity of violet-pumped white LEDs (e.g. [SORAA Bluefree/Zeroblue/Healthy](https://www.soraa.com/soraa-pro/technology/zeroblue.php), [Nichia Optisolis](https://www.nichia.co.jp/en/product/led_sp_optisolis.html), [YUJILEDS VTC range](https://www.yujiintl.com/tunable-spectrum.html), [Seoul SunLike](http://www.seoulsemicon.com/en/technology); and the the trend [to reduce 460 nm pumped white LEDs? (Leslie Lyons)](https://www.ledsmagazine.com/leds-ssl-design/article/14039534/is-it-time-to-say-goodbye-to-bluepump-leds-magazine)), and interesting question would be how colors are perceived and what are the nonvisual effects of such light sources through dense ocular media in elderly?

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/violetPumpedLEDs_and_ocularMedia.png)

***(A)** [Petteri Teikari (2012) PhD thesis](https://tel.archives-ouvertes.fr/file/index/docid/999326/filename/TH2012_Teikari_Petteri_ii.pdf) discussion, **(B)** [SORAA Bluefree/Zeroblue/Healthy](https://www.soraa.com/soraa-pro/technology/zeroblue.php) marketing material with the violet-pumped white LED, **(C)** Nichia's alternative ([Nichia Optisolis](https://www.nichia.co.jp/en/product/led_sp_optisolis.html)) to SORAA Zeroblue line. Along with the advertised "circadian protection", the violet-pumped LEDs give broader light spectrum, thus better color rendering as well*

## Literature references

* **Purkinje imaging for crystalline lens density measurement** (2018), https://www.slideshare.net/PetteriTeikariPhD/purkinje-imaging-for-crystalline-lens-density-measurement
* **Multispectral Purkinje Imaging** (2018), https://www.slideshare.net/PetteriTeikariPhD/multispectral-purkinje-imaging
* **Novel system for measuring the scattering of the cornea and the lens** (2018) by Pau Santos Vives (PhD thesis from UPC, Barcelona), https://upcommons.upc.edu/handle/2117/121192
* **System based on the contrast of Purkinje images to measure corneal and lens scattering** by Pau Santos (2018), https://doi.org/10.1364/BOE.9.004907
* **Optical quality of the eye lens surfaces from roughness and diffusion measurements** (1986) by Rafael Navarro et al. https://doi.org/10.1364/JOSAA.3.000228

## TODO for more detailed simulation

### PSF of ocular media layers

It would be interesting to have some estimate of the **point-spread-function (PSF)** of the different surfaces, as remember that (from [Navarro et al. 1986](https://doi.org/10.1364/JOSAA.3.000228)):

*The **first and the fourth Purkinje images** can be considered **specular** images, whereas the **second and the third are diffuse**. The first image is specular because, in spite of the roughness of the corneal epithelium, the reflection takes place in the surface of the tear layer that covers the anterior surface of the cornea.* 

And from [Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192):

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/pauSantos2018_fresnelEquations_purkinjeImages.png)

Thus, qualitatively it is very hard to capture the 2nd and 3rd Purkinje Images, and when you remember where the reflections are coming (see below), realistically you can hope to capture the difference between the 1st and 4th Purkinje image (i.e. the ocular media density without knowing how much cornea and crystalline lens contribute). In practice this is all you want to know when wanting to know how to pre-filter your light stimulus to ensure that the retinal irradiance / photon flux is constant across your subjects (i.e. you want to study if there are [compensatory mechanisms with aging at "ocular"/retinal/(sub)cortical level](https://doi.org/10.1371/journal.pone.0085837) with age for non-image forming (NIF) photoreception)

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/purkinjeSchematics.png)

***(A)** Purkinje schematic modified from [Cavero et al. 2017](http://doi.org/10.1152/advan.00068.2017) showing the "impedance discontinuities" (if you are an electrical engineer) / refractive index discontinuities (optics) which cause the reflections that we call Purkinje(-Samson) images after Jan Evangelista Purkinje, **(B)** Locations of the Purkinje images assuming the Le Grand theoretical eye model and a distance of 500 mm between the object and the eye (x is taken from the corneal apex). The author also included some simulated optical layout on Zemax if you have a license and the skills for it ([Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192)), **(C)** Purkinje images (left) from healthy eye (top) with a cataract (middle) and eye with a corneal opacification (bottom), and the corresponding 3rd Purkinje Image (P3) and 4th Purkinje image (P4) intensity profiles (right). The values of P3 and P4 contrasts are also given ([Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192)).*

#### Zemax model with proper optomechanical alignment?

Might take some optimization to get nicely separated Purkinje Images (see below A for [Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192)'s analysis on the relation image size and object distance) with extra set of non-Purkinje reflection possibly occurring (see below B from [Mariana Quelhas Dias Rodrigues Almeida (2012)](https://www.semanticscholar.org/paper/Detection-of-purkinje-images-for-automatic-of-and-Almeida/9e9cf0d52edded3151898e21db6634d98a8b6f9b)). 

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/purkinjeImageSeparation.png)

***(A)** [Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192), **(B)** from [Mariana Quelhas Dias Rodrigues Almeida (2012)](https://www.semanticscholar.org/paper/Detection-of-purkinje-images-for-automatic-of-and-Almeida/9e9cf0d52edded3151898e21db6634d98a8b6f9b)*

You can see nicely from the little animation from [Tabarnero and Artal 2014](https://doi.org/10.1371/journal.pone.0095764), how Purkinje Images move in relation to eye movements (Explaining why Purkinje images have been used for eye tracking purposes, see e.g. [Cornsweet and Crane 1973](https://doi.org/10.1364/JOSA.63.000921); and to aid the detection of fake eyes in biometric applications, see e.g. [Lee et al. 2008](https://doi.org/10.1117/1.2947582))

![alt text](https://s3-eu-west-1.amazonaws.com/ppreviews-plos-725668748/1553946/preview.gif)

*9° center to temporal (abducting) saccade. The tracking of the **1st Purkinje image** (corneal reflection) was marked with a **white** filled circle while tracking of the **4th Purkinje image** (lens posterior surface reflection) was marked in **green**. The pupil profile was characterized with a solid red line and its center marked in a **red dot**. Crystalline lens reflection (4th Purkinje image) wobbled for a fraction of a second after the saccadic movement. Some wobbling of the pupil center was also visible but to a less extent than the crystalline lens wobbling.*

[Aguirre 2019](http://dx.doi.org/10.1038/s41598-019-45827-3) has also open-source 3D ray-tracing MATLAB code for modeling the entrance pupil of the human eye, available in [https://github.com/gkaguirrelab/gkaModelEye](https://github.com/gkaguirrelab/gkaModelEye), that could be used potentially.

### Camera Modeling

At the moment the camera's quantum efficiency is imported with no idea of the absolute irradiance / photon flux of the light source(s) used. You want your setup to comply to the standard [ISO 15004-2:2007 “Ophthalmic instruments -- Fundamental requirements and test methods - Part 2: Light hazard protection”](https://www.iso.org/standard/38952.html) to not cause hazard for the eyes of the subjects. This in turn means that you should calculate your absolute irradiances in any case, and then you could plug those values to your camera model and measure/estimate the effect of camera selection to your final ocular media density estimates?

[Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192) serves again as nice reference how to calculate the limit values for continuous-wave instruments (opposed to pulsed light source with high peak values):

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/safetyLimits.png)

_Table 3.2 of the ISO 15004-2:2007 “Limit values for continuous wave instruments”, Group 1 limit values for continuous wave instruments (Table 2, 5.4.1.4 of the ISO 15004-2:2007; Table 2, 5.4.1.6 of the ISO 15004-2:2007)_

#### Illumination compensation

You can use the spectral sensitivity (defined either for photon flux or for irradiance) to increase the intensity of wavelengths for which your camera's sensor is less sensitive. For example our example Sony IMX is the least sensitive to 380 nm (within the range 380-700nm, _see below_)

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/cameraSensitivity_IMX252_Sony_FLIR_Blackfly.png)

The correction is not that massive in the end (2.5x increase ~ 0.4 log unit increase) compared for example to the 10x (1 log unit) increase of 410 nm light stimulus by [Johnson et al. 1993](https://www.ncbi.nlm.nih.gov/pubmed/8302531) who had otherwise problems in detecting 4th Purkinje image at all.

We can simulate (computed in [`estimate_illumination_compensation()`](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/40f097a7c9f73dc0b5fa61deaaf5621fa98e5b1a/sensitivity_analysis_wrapper.m#L247)the needed illumination compensation using the ocular media model by [van de Kraats and van Norren 2007](https://doi.org/10.1364/JOSAA.24.001842) which will give a estimate for nice pre-correction in order to have a better use of the dynamic range of the camera:

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/illuminationCorrection_on_lensDensity.png)

_Note that the compensation is slightly larger per used peak wavelength when half-bandwidth (`hbw`) is really narrow, and we can see that the 410 nm light indeed attenuates around 1 log unit for the 25 year old standard observer. To reproduce this, you can run [plot_compensated_lights.m)](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/plot_compensated_lights.m) which will load the pre-computed variables from `compensated_lights.mat`_

We can then combine the camera sensitivity -based compensation and lens density -based corrections with a standard interference filter `hbw` of 10 nm giving the following compensation curves:

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/illuminationCorrection_on_lensDensity_and_CameraSensitivity.png)

_The 60 year old template lens should have as large as 2 log unit compensation if you would be using 400 nm peak wavelengths by simple transmittance attenuation analysis_

You naturally have to take un-compensate this then in your analysis code, and use multiple exposures (HDR) to acquire both 1st and 4th Purkinje image in the elderly without intensity saturation as their intensity difference is so large.

### Limitations

#### Lack of spatial map

We really cannot get the crystalline lens density as a spatial map (as possible with SS-OCT with NIR Laser, see e.g.  [Alberto de Castro et al. 2018](https://doi.org/10.1167/iovs.17-23596); and EU's [Galahad Project](https://galahad-project.eu/) for developing low-cost supercontinuum light sources allowing visible light OCT, e.g. [Shu et al. 2019](https://dx.doi.org/10.21037%2Fqims.2019.05.01) and [Chong et al. 2018](https://doi.org/10.1364/BOE.9.001477)), thus the interest of big pharma is probably limited for using Purkinje images-based system to track the efficacy of their cataract-stopping/reversing medication. Likewise, some researchers working on Alzheimer's Disease might want to revisit the "biomarker hunt" with equatorial supranuclear cataracts below the lens capsule (see e.g. [Goldstein et al. 2003](https://doi.org/10.1016/S0140-6736(03)12981-9), [Michael et al. 2013](https://doi.org/10.1016/j.exer.2012.10.012); and reviewed by [Chang et al. 2014](https://doi.org/10.1016/j.jalz.2013.06.004). See below examples of SS-OCT scans:

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/OCT_crystallineLens.png)

***(A)** Optical coherence tomography images obtained from the CASIA2 anterior and posterior lens boundary are automatically drawn (orange dot lines), and their curvatures are calculated by the built-in software. Optic axis of lens (vertical orange dot lines) and vertex normal (vertical blue solid line) are automatically drawn and crystalline lens thickness is also calculated by the built-in software (vertical orange solid line) [Shoji et al. 2016](http://dx.doi.org/10.1136/bmjophth-2016-000058), **(B)**  Post-processing of volumetric SS-OCT data of the 26-yo healthy young subject. (a) Signal from the lens of the motion-corrected volumetric data is segmented. Anterior and posterior capsule, anterior and posterior cortex and the nucleus are segmented to enable determination of different parameters in those components. (b) Sagittal (side) projection (MIP) of the crystalline lens. (c) Examples of en-face projections of the lens capsule, nucleus and the cortex. Images were not corrected for light refraction [Grulkowski et al. 2018](https://doi.org/10.1364/BOE.9.003821), **(C)** . Posterior subcapsular cataract imaged with the SS-OCT in a 53-year-old (top row) and a 77-year-old (bottom row) pre-cataract surgery male patient. Central cross-section (A, E), lateral projection (B, F) of the maximum intensity, axial projection of the anterior (C, G), and the posterior (D, H) part of the crystalline lens. Although the anterior segment of the crystalline lens (C, G) seems normal, the observation of the posterior segment (D, H) reveals the shape and extent of the posterior subcapsular cataract. Scale bars: 1 mm [Alberto de Castro et al. 2018](https://doi.org/10.1167/iovs.17-23596).*

#### Need for high dynamic range -> higher setup cost

The "need for >8-bit dynamic range increased the cost of the camera needed, thus some computational approaches are needed for "multiframe-HDR" probably and use of some embedded deep learning-"compatible" platform such as NVIDIA Nano / NVIDIA Xavier NX (see [define_camera_spectral_sensitivity.m](https://github.com/petteriTeikari/spectralLensDensity_purkinjeImages/blob/37c7bdd0cd91462e6c85d4375b8289488a8eb66a/define_camera_spectral_sensitivity.m#L57) for some links to start your search)

#### Intraocular light scatter as extra?

Combination of this ocular media density assessment with the intraocular light measurement by [Pau Santos (2018)](https://upcommons.upc.edu/handle/2117/121192)) (to replace/augment [OCULUS C-Quant from 2005](https://www.oculus.de/en/products/visual-test-equipment/c-quant/highlights/) / [Visiometrics  HD Analyzer](https://www.visiometrics.com/hd-analyzer/) / [Oculus Pentacam Scheimpflug](https://www.aao.org/focalpointssnippetdetail.aspx?id=5b89b5e8-19d4-4e49-9edf-d791ce4497a1)) would be interesting? And if you put effort in making the device as inexpensive and even open-source, it could be used in a lot of photoreception laboratories and low-resource settings routinely if the user experience (UX) is good (as the cost of SS-OCT "gold standard" is quite substantial for non-spectral purposes).

You should note that Purkinje Images only measure the backward scatter (reflected back to the image sensor), and not the forward scatter that would need some psychophysics method (e.g. [CATRA](https://doi.org/10.1145/2010324.1964942)). 

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/intraocularLightScatter.png)

***(left)** Angular dependence of light scattering at the center of the lens of a 50‐year‐old donor for four wavelengths indicated as 4 = 400 nm, 5 = 500 nm, 6 = 602 nm, 7 = 700 nm. The experimental data are explained with a two component model: (1) the Rayleigh component (set of four dashed lines, widely apart, showing a minimum at 90° because of the natural light correction). The Rayleigh component dominates from 40° upward, including backward (towards the slit lamp) scatter. (2) the non‐Rayleigh (i.e. Mie) component (set of four sloping dashed lines) dominating in forward direction as important for vision. The four dashed lines of this component are less widely apart because the wavelength dependence of this component is less strong., **(right)** Model PSF of the human eye for a normal case and a case with increased light scatter (black and grey respectively), compared to the two major optical phenomena, total aberration (red), and lens light scatter (green). The scatter is broken down in the Rayleigh component (dashed) and in the non‐Rayleigh component (continuous). The PSF models are according the CIE standard for the effects of scatter (glare) on the PSF, mainly based on psychophysics [Vos and van den Berg 1999](https://scholar.google.com/scholar?cites=13451261557697564070&as_sdt=2005&sciodt=0,5&hl=en). The green lines are from in vitro measurements on donor eye lenses. The red line is based on the aberration model of [Thibos et al. 2002](https://onlinelibrary.wiley.com/servlet/linkout?suffix=null&dbid=16&doi=10.1111%2Fopo.12426&key=10.1364%2FJOSAA.19.002329) for normal eyes. The black and light green lines are for the young normal condition, the grey and dark green lines are for a cataractous condition. The scatter (>1°) part of the PSF contains also contributions from the cornea, and other parts of the eye, making it a bit higher.*

##### Assessment of glare in architectural lighting and as a predictor of driving performance in the elderly

The intraocular light scatter measurement device could be useful in lighting design studies when quantifying glare *in situ* and especially among elderly population that have higher intraocular light scatter?

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/glare.png)

***(A)** Intraocular light scatter in aged population is particularly disabling when driving (see e.g. [van den Berg et al. 2009](https://doi.org/10.3921/joptom.2009.112) and [Ortiz-Peregrina et al. 2020](https://doi.org/10.1371/journal.pone.0227892)), **(B)** It is not always trivial how to even evaluate glare, so you could have a look of the review of current state-of-the-art by [Wienold et al. 2019]() with the basic definitions of architectural lighting glare from [Professional Electricial (2018)](https://professional-electrician.com/technical/the-glare-essentials/), **(C)** Different devices and software for measurement; (above) [LDA LumiDisp Luminance Analyzer](http://www.lumidisp.eu/glare-measurement/) able to carry out [Unified Glare Index (UGR) evaluation](https://www.luxreview.com/2016/10/05/is-that-fitting-ugr19-compliant/), (left-bottom) Raspberry Pi-based luminance meter from [Kruisselbrink et al. 2017](https://doi.org/10.26607/ijsl.v19i1.76), (right-bottom) Veiling glare index measurement with a new yesy system from [Scopatz 2017](https://doi.org/10.1117/12.2262881).*

#### Open-Source Hardware

Practiacal low-cost open-source hardware (see e.g. [Pearce 2012](http://doi.org/10.1126/science.1228183), cited by [451 articles](https://scholar.google.com/scholar?um=1&ie=UTF-8&lr&cites=1682268685332266761)) implementation could be inspired for example by

* Monocular focus estimation setup for Augmented and Virtual Reality (AR, VR) applications, using wearable eyetracker for mechanical stability ([Itoh et al. 2017](https://doi.org/10.1109/VR.2017.7892252), below A)

* Hyperspectral iris imaging system (below B) by [Di Cecilia and Rovati 2020](https://doi.org/10.1063/1.5125575), who are using monochrome camera with a monochromator for tunable light spectrum, and who want to avoid Purkinje images on top of iris.

* Smartphone-based imaging system (below C) of the corneal endothelium by [Toslak et al. 2016](http://dx.doi.org/10.1080/09500340.2016.1267815), that used the 2nd Purkinje image to image the endothelial cells (below D).

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/purkinjeImaging_openSourceHardware.png)

***(A)** Overview of our system. (a) A headset with an infrared eye camera and RGB scene camera; a focus chart on a linear rail used in the evaluation. (b) Simplified diagram of the light paths of Purkinje-Sanson (PS) images that occur on the surface of the eye. (c) A close-up eye image that shows the PS images and a typical output image of our detection method tuned for P3 ([Itoh et al. 2017](https://doi.org/10.1109/VR.2017.7892252)), **(B)** Picture of the GS3-U3-32S4M-C camera and illumination holder for bifurcated fibers from monochromator output ( [Di Cecilia and Rovati 2020](https://doi.org/10.1063/1.5125575)), **(C)**  (a) Photographs of the slit lamp microscope (b) and custom-made smartphone adapter ([Toslak et al. 2016](http://dx.doi.org/10.1080/09500340.2016.1267815)), **(D)**  Purkinje images I to IV (a). Images of corneal layers taken at 40× magnification (b) and 40× magnification of the biomicroscope with 6× digital magnification of the smartphone (c). ([Toslak et al. 2016](http://dx.doi.org/10.1080/09500340.2016.1267815))*

Or take inspiration from "Arduino Ophthalmology" and visual neurosciences applications (e.g. [Teikari et al. 2012](https://doi.org/10.1016/j.jneumeth.2012.09.012)):

![alt text](https://raw.githubusercontent.com/petteriTeikari/spectralLensDensity_purkinjeImages/master/figures/arduino_ophthalmology.png)

***(A)** Pupillary Light Reflex (PLR) study with Arduino-driven illumination by [González et al. 2017](https://doi.org/10.1109/CONIELECOMP.2017.7891817), **(B)** Arduino-based design for low-cost pattern electroretinography (ERG) from [McInturff and Buchser 2015](http://doi.org/10.1515/bmt-2015-0042) (see also [Pradhikari et al. 2019](https://doi.org/10.1016/j.visres.2019.08.007)'s system with Arduino for melanopsin-dependent white noise ERG), **(C)** Arduino used for trigger pulses, with its better real-time performance over the mini PC (NUC), in the low-cost Optical Coherence Tomography (OCT) system by [Kim et al. 2018](https://dx.doi.org/10.1364%2FBOE.9.001232), [Song et al. 2019](https://doi.org/10.1167/tvst.8.3.61)*
