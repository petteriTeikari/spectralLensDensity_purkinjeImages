function density_error_plot(density_array, ideal_density_array, density_diff_array, age_vector, ...
                            hbw_names, hbw_nms, peak_wavelengths, ...
                            lambda, light_sources_array, ideal_SPD_array, ...
                            camera_sensitivity, camera_metadata)
    
    disp('4.1.Plot) Visualizing the error landscapes')    
    if nargin == 0
        load plot_debug.mat
    else
        save plot_debug.mat    
    end
    
    %%
    
    density_to_use = 'diff'; % you could make a cell and loop all through if you wanted
    no_of_hbws = length(hbw_names);
    
    % As we have 3 parameters, hard to visualize in contour map, easier to
    % split to subplots based by the chosen hbw that is limited by the
    % available filters / light sources (whereas subject ages are really
    % continuous, and we could in theory want to have the test lights at
    % very narrowly spaced if they can be switched fast with a fast camera)
       
    % init figure
    scr = get(0,'ScreenSize');
    close all
    fig = figure('Color', 'w', 'Name', 'Error Landscape of Ocular Media Density estimation');
    set(fig, 'Position', [0.1*scr(3) 0.4*scr(4) 0.8*scr(3) 0.5*scr(4)])
    
    % subplot params
    rows = 2; cols = 3;       
    
    % choose which density to plot
    if strcmp(density_to_use, 'diff')
        densityToPlot = density_diff_array;
    elseif strcmp(density_to_use, 'ideal') % more like for debug
        densityToPlot = ideal_density_array;
    elseif strcmp(density_to_use, 'realLife') % more like for debug
        densityToPlot = density_array;
    end
    
    % get density range for plotting
    OD_range = get_density_range(densityToPlot, false);
    
    %%
    for hbw = 1 : no_of_hbws                        
        
        % human-understandable variables        
        densities_per_hbw = squeeze(densityToPlot(hbw, :, :)); % e.g. 14 x 76
        hbw_nm = hbw_nms(hbw); 
        hbw_name = hbw_names{hbw};
        
        % call a subfunction
        sp(hbw) = visualize_error_per_hbw(densities_per_hbw, hbw_nm, hbw_name, ...
                                          peak_wavelengths, age_vector, ...
                                          rows, cols, hbw, ...
                                          OD_range);
        
    end
    
end

function sp = visualize_error_per_hbw(densities_per_hbw, hbw_nm, hbw_name, ...
                                      peak_wavelengths, age_vector, ...
                                      rows, cols, hbw, ...
                                      OD_range)


      %% whos                               
       sp = subplot(rows, cols, hbw);
       
       % plot as contour map
       x = age_vector;
       y = peak_wavelengths;
       [X,Y] = meshgrid(x,y);
       [C,h] = contourf(X, Y, densities_per_hbw);
       set(h,'LineColor','none')
       
       % set custom colormap and shared range for all the hbws
       colormap jet 
       h = colorbar;       
       caxis(OD_range);
       
       % label contour plot elevations if it does not get too messy?
       % or/and use contour() instead of contourf()
       % https://uk.mathworks.com/help/matlab/ref/clabel.html
              
       % add annotations
       t = title({['Half-bandwidth (hbw) = ', num2str(hbw_nm), ' nm']; hbw_name});
       xL = xlabel('Age [yrs]');
       yL = ylabel('\lambda_p_e_a_k [nm]');
       title(h,{'\DeltaOD', 'Real-Ideal'})
       
       % style here
       set(gca, 'FontName','NeueHaasGroteskDisp Pro', 'FontSize', 8)
       set([t xL yL], 'FontName','NeueHaasGroteskDisp Pro', 'FontSize', 10)
       % set(gca, 'YLim', [400 600])
       
       
end

function OD_range = get_density_range(densityToPlot, symmetrize) 

    % e.g. [-3.3275 0.2716]
    OD_range = [min(densityToPlot(:)) max(densityToPlot(:))];
    
    
    if symmetrize
        % we will make this symmetric as we are using bicolor colormap to
        % have the color to indicate the sign as well
        % In practice a lot of unused colors this way :(
        abs_range = abs(OD_range);
        if abs_range(1) > abs_range(2)
            OD_range(2) = -1 * OD_range(1);
        else
            OD_range(1) = -1 * OD_range(2);
        end
        % TODO fail if all values are negative or positive
    end
    

end