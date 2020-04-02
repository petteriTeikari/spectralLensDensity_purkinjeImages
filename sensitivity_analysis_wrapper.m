function sensitivity_analysis_wrapper(lambda, hbw_names, hbw_nms, peak_wavelengths, age_res,...
                                      light_sources_array, camera_sensitivity, camera_metadata, illumination_camera, verbose)

    %% Brute-force grid search for all the combos
    [density_array, ideal_density_array, density_diff_array, ideal_SPD_array, ...
        compensated_SPD_array, compensation_multipliers, ...
        age_vector, lensDensity_template_LOG] = ...
            compute_density_error(lambda, hbw_names, hbw_nms, peak_wavelengths, age_res, ...
                                  light_sources_array, camera_sensitivity, camera_metadata, verbose);
      
    %% Plot the error landscapes
    density_error_plot(density_array, ideal_density_array, density_diff_array, age_vector, ...
                       hbw_names, hbw_nms, peak_wavelengths, ...
                       lambda, light_sources_array, ideal_SPD_array, ...
                       camera_sensitivity, camera_metadata);
                   
    %% Plot the Lens Density
    ages_to_use = [25 45 60 75 88];
    plot_lens_density(ages_to_use, age_vector, lambda, lensDensity_template_LOG)
    
    %% Plot the light compensation
    % use the same ages as above to avoid all-clogged-up graphs
    hbw_to_pick = 10;
    plot_compensated_lights(ages_to_use, age_vector, hbw_names, hbw_nms, hbw_to_pick, ...
                            peak_wavelengths, lambda, illumination_camera, ...
                            compensated_SPD_array, compensation_multipliers)

end

function [density_array, ideal_density_array, density_diff_array, ideal_SPD_array, ...
          compensated_SPD_array, compensation_multipliers, ...
          age_vector, lensDensity_template_LOG] = ...
            compute_density_error(lambda, hbw_names, hbw_nms, peak_wavelengths, age_res, ...
                                  light_sources_array, camera_sensitivity, camera_metadata, verbose)
             
    tic;
    
                              
    %%
    lights_size = size(light_sources_array);
    wavelength_vector_length = lights_size(1);
    no_of_halfBandwidths = lights_size(2);
    no_of_peakWavelengths = lights_size(3);    
    
    % create the age vector
    min_Age = 15; max_Age = 90; 
    age_vector = (min_Age:age_res:max_Age)';
    no_of_ages_to_test = length(age_vector);
    
    no_of_combinations = no_of_halfBandwidths * no_of_peakWavelengths * no_of_ages_to_test;
    disp(['4.1) Computing ocular media density errors (no of combinations = ', ...
          num2str(no_of_combinations), '), using the following ages:']); fprintf('    ')
    
    % Output array is now 3D with free simulation parameters
    % 1) Half-bandwidth
    % 2) Peak Wavelength of the ligth
    % 3) (Virtual) Age of the subject/patient
    density_array = zeros(no_of_halfBandwidths, no_of_peakWavelengths, no_of_ages_to_test);
    ideal_density_array = zeros(no_of_halfBandwidths, no_of_peakWavelengths, no_of_ages_to_test);
    density_diff_array = zeros(no_of_halfBandwidths, no_of_peakWavelengths, no_of_ages_to_test);
    
    % if you want to later plot these
    ideal_SPD_array = zeros(wavelength_vector_length, no_of_halfBandwidths, no_of_peakWavelengths, no_of_ages_to_test);
    compensated_SPD_array = zeros(wavelength_vector_length, no_of_halfBandwidths, no_of_peakWavelengths, no_of_ages_to_test);
    compensation_multipliers = zeros(no_of_halfBandwidths, no_of_peakWavelengths, no_of_ages_to_test);
    
    % if you want to visualize the different lens densities as function of
    % age, we can output these as well
    lensDensity_template_LOG = zeros(wavelength_vector_length, no_of_ages_to_test);
            
    for age_idx = 1 : no_of_ages_to_test
        for peak_nm = 1 : no_of_peakWavelengths
            for hbw = 1 : no_of_halfBandwidths                    
                
                % Use more human-readable variable names
                age = age_vector(age_idx);                
                light_SPD = light_sources_array(:,hbw,peak_nm);                         
                peakNm = peak_wavelengths(peak_nm);
                
                % not really used atm for computations
                % but could be used in titles/ticks/etc if wanted
                hbwNm = hbw_nms(hbw);
                hbwName = hbw_names{hbw};
                
                % "progress bar"
                if rem(age_idx, 1) == 0 && peak_nm == 1 && hbw == 1
                    fprintf([num2str(age), ' '])
                end
                
                % Create the lens density template based on the age
                nm_resolution = lambda(2)-lambda(1);
                [~, lensDensity_template_LOG(:,age_idx), ~] = lensMediaWrapper(age, nm_resolution);
                
                % Wrapper for density density error calculation
                [ideal_density, density, density_diff, ideal_SPD] = ...
                calculate_relativeLensDensity(lambda, lensDensity_template_LOG(:,age_idx), light_SPD, ...
                                              camera_sensitivity, camera_metadata, ...
                                              peakNm, age, hbwNm, hbwName, verbose);
                                          
                % Assign the scalar outputs to output arrays
                density_array(hbw, peak_nm, age_idx) = density;
                ideal_density_array(hbw, peak_nm, age_idx) = ideal_density;
                density_diff_array(hbw, peak_nm, age_idx) = density_diff;
                ideal_SPD_array(:, hbw, peak_nm, age_idx) = ideal_SPD;
                
                % Compute the illumination compensation for every
                % light stimuli based on the age-parametrized template
                [light_compensated, light_comp_multiplier] = estimate_illumination_compensation(lambda, lensDensity_template_LOG(:,age_idx), light_SPD);
                % disp([age peakNm hbwNm light_comp_multiplier sum(light_SPD)]) % Debug command window / console
                compensated_SPD_array(:, hbw, peak_nm, age_idx) = light_compensated;
                compensation_multipliers(hbw, peak_nm, age_idx) = light_comp_multiplier;
                
            end            
        end        
    end  
    
    fprintf('\n'); disp(['    ... done in ', num2str(toc), ' seconds'])
    % e.g. ... done in 5.8438 seconds for 6,384 combinations ~ 0.9 ms per iteration
    %         (14 wavelengths * 76 ages * 6 hbws, nm_resolution = 0.1 nm)
    % e.g. ... done in 168.119 seconds for 181,944 combinations 
    %         (399 wavelengths * 76 ages * 6 hbws, nm_resolution = 0.1 nm)
    % TODO! think of speeding up with parfor tweaks


end


function [ideal_density, realLife_density, density_diff, ideal_SPD] = ...
         calculate_relativeLensDensity(lambda, lensDensity_template_LOG, light_SPD, ...
                                       camera_sensitivity, camera_metadata, ...
                                       peakNm, age, hbwNm, hbwName, verbose)

    % We now make some assumptions:
    %
    %   1) The age-parametrized template by van de Kraats and van Norren (2007)
    %      always is "accurate", and we always find the real physiological
    %      lens density by just finding the correct age ("virtual age")
    % 
    %   1.1) With this assumption, we weigh the lens density template with
    %        the light SPD (with hbw as peak_nm as free parameters) and compare 
    %        this to the "ground truth" of the SPD of being all on one
    %        wavelength (depending on your nm_resolution)
    %
    %   If there is really no error introduced in practice (or you can test
    %   for the statistically significance), you do not really care about
    %   the choice of hbw on any peak_wavelength. As a hypothesis, you would
    %   expect that on shorter wavelengths the error becomes larger as the
    %   lens density template changes the most on that range
   
    % TODO! The lens media template includes the Rayleigh scatter
    % component, but you could think that especially with lower
    % wavelengths, the scattering in old eye might not follow the model?
    % And broader spectrum could have more uncertainty?
    
    % TODO! 
    % Camera_sensitivity does not really influence on these theoretical
    % computation in anyway as weighing both ideal_SPD and the light_SPD
    % should cancel out. However in reality, the SNR is getting reduced on
    % the parts of the spectral window with poor quantum efficiency (i.e.
    % more photons are captured around 550 nm than on 380-410 nm). But this
    % could require some absolute photon flux levels with the sensor
    % datasheet noise/sensitivity parameters
   
    % Compute the error compared to narrowest light source
    % ("ground truth"/"gold standard") with the used 
    % nm_resolution (e.g. default 0.1 nm)                    
    lambda_idx = find(lambda == peakNm);
        
    % Create the ideal SPD putting all the energy on that peak wavelength
    if ~isempty(lambda_idx)
        ideal_SPD = zeros(length(lambda),1);
        ideal_SPD(lambda_idx) = 1;        
    else
        % peak_wavelengths could be rounded or something if you try to use
        % too high precision compared to nm_resolution 
        % TODO! add some error handling
        error(['The desired peakNm = ', num2str(peakNm), ...
            ' nm was not found from the used wavelength vector! Typo/Why?']) 
    end    
  
    % Ideal DENSITY            
    ideal_density = compute_density_lowLevel(ideal_SPD, lensDensity_template_LOG);
    realLife_density = compute_density_lowLevel(light_SPD, lensDensity_template_LOG);
    density_diff = realLife_density - ideal_density;
    
    if verbose
      
        % LIGHT INPUT
        %         fprintf(['SPD Irradiance = ', num2str(trapz(light_SPD),'%1.2f'), '\t', ...
        %                  'Ideal SPD Irradiance = ', num2str(trapz(ideal_SPD),'%1.2f'), ...
        %                  '\n'])      
        %         
        % OUTPUT 
        fprintf([' Age = ', num2str(age), ', Peak Nm = ', num2str(peakNm), ...
                 ', hbw = ', num2str(hbwNm), '\t', ...
                 'Density = ', num2str(realLife_density,'%1.2f\n'), ' OD\t', ...
                 'Ideal Density = ', num2str(ideal_density,'%1.2f\n'), ' OD\t', ...
                 'Density_diff = ', num2str(density_diff,'%1.2f\n'), ' OD, ', ...
                 ' (', hbwName, ')\n'])
    end
    
end

function density_scalar = compute_density_lowLevel(SPD, lensDensity_template_LOG)

    computation_in_LIN = true;

    % Convert len
    if computation_in_LIN
        density_linear = 10.^ lensDensity_template_LOG;        
        spectral_density =  density_linear .* SPD;
    else
        % trapz fails with NaNs
        SPD_log = convert_LightSPD_to_LOG(SPD);
        SPD_log_NaNidxs = isnan(SPD_log);
        nonnan_lensDensity = lensDensity_template_LOG(~SPD_log_NaNidxs);
        nonnan_SPD_log = SPD_log(~SPD_log_NaNidxs);    
        
        % densities per remaining wavelengths
        % Linear multiplication becomes LOG sum, get first the vector sum,
        % i.e. most of the values will be zero or close to it
        spectral_density = nonnan_lensDensity + nonnan_SPD_log;
        
        % TODO! Debug   
    end
    
        
    % we want the total density now at the test wavelength
    % i.e. one density value per light stimulus
    if length(spectral_density) > 1
        density_scalar = trapz(spectral_density); 
            % res always the same, % TODO if your wavelength vectors start to be
            % funkier
    else
        % only single value left, i.e. with ideal SPD and with really
        % narrow linewidth lasers
        density_scalar = spectral_density; 
    end
    
    % return in LOG
    if computation_in_LIN
        density_scalar = log10(density_scalar);
    end

end

function [light_compensated, compensation_factor] = estimate_illumination_compensation(lambda, lensDensity_template_LOG, light_SPD)

    % save compensated.mat
    transmittance_linear = 10.^(1-lensDensity_template_LOG);
    % plot(transmittance_linear)
    
    % we need to remove the offset now from the long wavelength end as it
    % is not totally neutral over the ages, if we don't do this, you end up
    % actually reducing the light needed
    transmittance_linear = transmittance_linear / max(transmittance_linear(:));
    
    % this fix leads to another problem with all the wavelengths needing
    % increase in intensity, we need to remember to normalize these later
    % then, i.e. normalize per age 
    
    light_attn_vector = transmittance_linear .* light_SPD;
    sum_light_SPD_in = sum(light_SPD); % should be 1 if no bugs before
    % plot(light_attn_vector)
    
    %i.e. how much is the total light energy/photon flux reduced, NOT THE
    %PEAK attenuation
    light_attn = sum(light_attn_vector);
    compensation_factor = sum_light_SPD_in / light_attn;    
    light_compensated = light_SPD * compensation_factor;
    % plot(light_compensated)
    
end

function SPD_log = convert_LightSPD_to_LOG(SPD)

    %%
    SPD_log = log10(SPD);
    
    % Linear 0 -> -Inf
    inf_idx = isinf(SPD_log);
    SPD_log(inf_idx) = NaN;
    
    % TODO! if you do something else downstream that does not like NaNs,
    % tweak this for something else, like using some small epsilon or
    % something    

end