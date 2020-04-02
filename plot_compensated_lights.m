function plot_compensated_lights(ages_to_use, age_vector, hbw_names, hbw_nms, hbw_to_pick, ...
                            peak_wavelengths, lambda, illumination_camera, ...
                            compensated_SPD_array, compensation_multipliers)

    if nargin == 0
       load compensated_lights.mat % debugging from pre-computed lights 
    end
                        
    %% Set-up the plot
        
        min_wavelength_x = 400;
        max_wavelength_x = 600;
    
        % Get the age indices to plot
        [idx,loc] = ismember(ages_to_use, age_vector);
        age_idxs_to_out = loc(idx);

        % Get the hbw index to plot
        [idx,loc] = ismember(hbw_to_pick, hbw_nms);
        hbw_idx = loc(idx);
        hbw_name = hbw_names{hbw_idx};        

        % we want a 2D matrix
        % x-axis (first dimension) with all the peak wavelengths
        % y-axis (second dimension) with all the ages to plot       
        %compensated_SPDs_to_plot = squeeze(compensated_SPD_array(1, hbw_idx, :, age_idxs_to_out));
        % compensated_SPDs_to_plot = squeeze(compensated_SPD_array(1, :, :, age_idxs_to_out));
        %compensated_multipliers = squeeze(compensation_multipliers(hbw_idx, :, age_idxs_to_out));
        compensated_multipliers = squeeze(compensation_multipliers(:, :, age_idxs_to_out));
        
        % normalize the multiplier by age, i.e. set the smallest correction
        % to 1.00 (which is the longest wavelength)
        idx = peak_wavelengths == max_wavelength_x;

        size_multipliers = size(compensated_multipliers); % e.g. 6 x 201 x 4
        for age = 1 : size_multipliers(3)
           min_value = min(compensated_multipliers(:,idx,age));
           compensated_multipliers(:,:,age) = compensated_multipliers(:,:,age) / min_value;
        end
        
        clear compensated_SPD_array % smaller .mat to save
        save compensated_lights.mat % for debugging
        % whos
    
    %% Plot The Density Plot
    
        
        scr = get(0,'ScreenSize');    
        fig = figure('Color', 'w', 'Name', '"Factory" Illumination compensation with lens density template');
        set(fig, 'Position', [0.1*scr(3) 0.1*scr(4) 0.8*scr(3) 0.65*scr(4)])
        rows = 3; cols = 2; 
        
        legend_str = cell(length(ages_to_use),1);
        for l = 1 : length(ages_to_use)
            legend_str{l} = [num2str(ages_to_use(l)), ' yrs']; 
        end
        
        idx = peak_wavelengths == min_wavelength_x;
        max_value_of_all_ages = max(max(compensated_multipliers(:,idx,:)))
        
        for hbw = 1 : size_multipliers(1)
                    
            sp(hbw) = subplot(rows,cols, hbw);
            to_plot_2D = squeeze(compensated_multipliers(hbw, :, :));
            p(:,hbw) = semilogy(peak_wavelengths, to_plot_2D);

            titStr = sprintf('%s\n%s', 'Illumination correction with lens density template', ...
                             [hbw_names{hbw}, ', hbw = ', num2str(hbw_nms(hbw)), ' nm']);

            t(hbw) = title(titStr);
            xL(hbw) = xlabel('Wavelength [nm]');
            yString = sprintf('%s\n%s', 'Normalized Illumination', ...
                              'Correction [LOG]');
            yL(hbw) = ylabel(yString);
            leg(hbw) = legend(p(:,hbw), legend_str, 'Interpreter', 'none', 'Location', 'SouthEast');
                legend('boxoff')        

        end
        
        set(sp, 'XLim', [min_wavelength_x max_wavelength_x], 'YLim', [1 1.05*max_value_of_all_ages])
        set(p, 'LineWidth', 2)

        % style here
        set(sp, 'FontName','NeueHaasGroteskDisp Pro', 'FontSize', 8)
        set([t xL yL], 'FontName','NeueHaasGroteskDisp Pro', 'FontSize', 10)
        
    %% Plot The Density Plot with the camera sensitivity data
    
        fig2 = figure('Color', 'w', 'Name', '"Factory" Illumination compensation with lens density template');
        set(fig2, 'Position', [0.2*scr(3) 0.1*scr(4) 0.5*scr(3) 0.40*scr(4)])
        
        % just a single hbw, 2D, e.g. 261 x 5
        compensated_multiplier_hbw = squeeze(compensation_multipliers(hbw_idx, :, age_idxs_to_out));
        
        % combine with the camera sensor-based compensation
        illumination_combined = combine_illumination_compensations(peak_wavelengths, lambda, ...
                                                                   compensated_multiplier_hbw, illumination_camera, ...
                                                                   max_wavelength_x);        
        
        max_value_of_all_ages2 = max(illumination_combined(idx,:))
                                                               
       %% PLOT
        p2 = semilogy(peak_wavelengths, illumination_combined);
        
        titStr = sprintf('%s\n%s\n%s', 'Illumination correction' , ...
                             'Lens Density Template + Camera Sensor Sensitivity', ...
                             [hbw_names{hbw_idx}, ', hbw = ', num2str(hbw_nms(hbw_idx)), ' nm']);

        t2 = title(titStr);
        xL2 = xlabel('Wavelength [nm]');
        yString = sprintf('%s\n%s', 'Normalized Illumination', ...
                          'Correction [LOG]');
        yL2 = ylabel(yString);
        leg2 = legend(p2(:,1), legend_str, 'Interpreter', 'none', 'Location', 'SouthEast');
            legend('boxoff')    
        
        set(gca, 'XLim', [min_wavelength_x max_wavelength_x], 'YLim', [1 1.05*max_value_of_all_ages2])
        set(p2, 'LineWidth', 2)

        % style here
        set(gca, 'FontName','NeueHaasGroteskDisp Pro', 'FontSize', 8)
        set([t2 xL2 yL2], 'FontName','NeueHaasGroteskDisp Pro', 'FontSize', 10)

    
    %% TODO!
    
        % we are missing the effect of the optics now still, which we can
        % assume to be the smallest over the visible range
    
end

function illumination_combined = combine_illumination_compensations(peak_wavelengths, lambda, ...
                                                                    compensated_multiplier_hbw, illumination_camera, ...
                                                                    max_wavelength_x)

        % pick the corresponding wavelengths from camera/illumination data
        [idx,loc] = ismember(peak_wavelengths, lambda);
        lambda_idxs_to_out = loc(idx);
        illumination_trim = illumination_camera(lambda_idxs_to_out);
        lambda_trim = lambda(lambda_idxs_to_out);
        
        % both compensations are now in linear units, so multiply
        illumination_combined = compensated_multiplier_hbw .* illumination_trim;
        
        % normalize for age (again), now for the largest peak wavelength to
        % be plotted
        idx = lambda_trim == max_wavelength_x;
        
        size_multipliers = size(illumination_combined); % e.g. 261 x 5        
        for age = 1 : size_multipliers(2)
           min_value = illumination_combined(idx,age);
           illumination_combined(:,age) = illumination_combined(:,age) / min_value;
        end

end