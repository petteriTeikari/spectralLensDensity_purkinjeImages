function densityModel_sensitivityAnalysis_v2020()

    close all

    %% Create the van de Kraats and van Norren (2007) lens template
    
        % outputs are in log, see inside lensMediaWrapper for linear (or change
        % the output as strucutre if that is easier for you)
        age = 25;
        nm_resolution = 0.1; % sets the resolution for all the SPDs
        [lambda, density, transmittance] = lensMediaWrapper(age, nm_resolution);
        
        disp(['1) Lens media template initialized with the spectral resolution fixed at ', ...
              num2str(nm_resolution), ' nm, and a range of [', num2str(lambda(1)), ',', num2str(lambda(end)), '] nm'])
        
    %% Create light sources used in simulation
    
        % reasonable real-life wavelenghts
        % peak_wavelengths = [385 390 405 415 430 445 460 480 505 530 560];
        
        % simulation looks prettier with continuous peaks
        nm_safety = 100; % leads to estimation errors if you go too close to the "edge" with broad SPD
        peak_wavelengths = (lambda(1)+nm_safety : 1 : lambda(end)-nm_safety)'; % some round-off-error around edges        
        [hbw_names, hbw_nms, light_sources_array] = lightSource_wrapper(lambda, peak_wavelengths);
    
    %% Define camera spectral sensitivity
    
        % You get this from the datasheet
        % Note! This is typically defined as "quantum efficiency" (thus
        % we match this to irradiance used by light_sources_array). TODO!
        % if you want to do these as photon fluxes
        model = 'FLIR-Blackfly-S-USB3';
        [camera_sensitivity, camera_metadata] = define_camera_spectral_sensitivity(model, lambda, false, true);
        ad
        
    %% Sensitivity Analysis after initialization        
        verbose = false;
        age_res = 1; % [in years]
        sensitivity_analysis_wrapper(lambda, hbw_names, hbw_nms, peak_wavelengths, age_res, ...
                                      light_sources_array, camera_sensitivity, camera_metadata, verbose)
        
end


