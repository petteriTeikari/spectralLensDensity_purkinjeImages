function [hbw_names, hbw_nms, light_sources_array] = lightSource_wrapper(lambda, peak_wavelengths, output_in_photons)

    if nargin == 2
       output_in_photons = false;
    end    
        
    % Manually defined HBWs from datasheets
    [hbw_names, hbw_nms] = define_light_source_hbws(lambda);
    
    % 3D output array (matrix) with dimensions
    % 1st - wavelength vector (e.g. 380 - 780 in 1 nm steps)
    % 2nd - different hbws used (e.g. 0.1, 1, 5, 10 nm)
    % 3rd - peak wavelengths (e.g. 405 nm, 550 nm), does not need to match
    %                        "rhodopsin psychophysics approach" 
    %                        (i.e. 410 nm vs 560 nm from
    %                        https://doi.org/10.1364/JOSAA.29.002469)
    
    no_of_peak_nms_to_simulate = length(peak_wavelengths);
    no_of_hbws = length(hbw_names);
    
    light_sources_array = zeros(length(lambda), no_of_hbws, no_of_peak_nms_to_simulate);
    
    % Loop through the peak wavelengths to simulate
    for p = 1 : no_of_peak_nms_to_simulate
        peak_nm = peak_wavelengths(p); 
        light_sources_array(:,:,p) = create_2D_lightmatrix_with_different_hbw(peak_nm, lambda, ...
                                                            hbw_names, hbw_nms, output_in_photons);
    end      
    
    disp('2) Light source SPD matrix defined with the various hbw and peak wavelengths')
    disp(['    ... peaks ranging from ', num2str(peak_wavelengths(1)), 'nm to ', num2str(peak_wavelengths(end)), ...
          ' nm, in ', num2str(peak_wavelengths(2)-peak_wavelengths(1)), ' nm increments'])

end

function light_SPD_2D_matrix = create_2D_lightmatrix_with_different_hbw(peak_nm, lambda, ...
                                                                        hbw_names, hbw_nms, output_in_photons)

    no_of_hbws = length(hbw_names);
    normalization_method = 'sum_to_unity';
    
    % Loop through the different half-bandwidths (hbw / FWHM)
    for h = 1 : no_of_hbws
        
        % We assume that all these (quasi)-monochromatic light sources have
        % Gaussian wavelength distributions which is more true for light
        % sources than for other ones 
        % (TODO! you could actually import here
        % some measured spectral power distributions if you are not happy
        % by creating synthetic spectra)
        SPD_1D_vector = monochromaticLightAsGaussian(peak_nm, hbw_nms(h), ...
                                                     lambda);
                                                 
        if output_in_photons            
            % TODO! copy from camera
        end
        
        if strcmp(normalization_method, 'sum_to_unity')
            % all our lights are now with the same spacing, thus the
            % resolution is not used
            total_irradiance = trapz(SPD_1D_vector);
            SPD_1D_vector = SPD_1D_vector / total_irradiance;
        else
           % only equal energy/photon flux atm implemented 
        end
        
        light_SPD_2D_matrix(:,h) = SPD_1D_vector;
    end

end

    
function [hbw_names, hbw_nms] = define_light_source_hbws(lambda) 
    
    nm_resolution = lambda(2)-lambda(1);

    % Some realistic light sources that you could use, better to have a
    % look also the commonly available wavelengths and designing your
    % Purkinje system around that
    
    % Remember that
    % Blu-ray uses 405 nm lasers explaining the good availability of such
    % lasers. Sora BlueFree white LED uses violet LED around 405 nm as the
    % pump. You have also common wavelengths at 405 nm for 
    % "Hg Emission Line, Alkaline Phosphatase, Acid Phosphatase, GGT, Amylase "
    hbw_names = {'TO-Can Narrow linewidth Laser'; ... % e.g. Ondax 405 nm CP-405-PLR12
                 'TO-Can Budget laser'; ... % e.g. Sony OPTLD004, Wavespectrum WSLD-405-150m-1 
                 '3 nm interference filter'; ... % e.g. Knight Optical 405 nm 405FIN25, BFI Optilas
                 '10 nm budget interference filter'; ... % e.g. EO 405 nm #65-618, or UV LED without filter, e.g. Luminus SST-10-UV
                 'Narrow-peak LED'; ... % e.g. Kingbright 405 nm ATDS3534UV405B 
                 'Cheapest SMD LED (£0.464/pc)'}; % e.g. Vishay VLMU3100-GS08    
    
    hbw_nms = [8.7500e-05 ... % sic! you read this right, 160 MHz@405 nm ~ 0.0875 picometers
               2 ...
               3 ...
               10 ...
               15 ...
               18];
               
    % now the Ondax is way too narrow for our simulation wavelengths
    hbw_nms = (1/nm_resolution) * hbw_nms;
    hbw_nms = ceil(hbw_nms) / (1/nm_resolution);
    
    % e.g. at 0.1 nm resolution, this peak becomes 0.1 nm, 
    % i.e. the ideal SPD
    
end