function plot_lens_density(ages_to_use, age_vector, lambda, lensDensity_template_LOG)

    if nargin == 0
        % for debug
        load lens_density_plot.mat        
        ages_to_use = [25 45 60 75 88]; % over-ride original
    else
        save lens_density_plot.mat
    end
    close all

    %% Get the age indices to plot
    [idx,loc] = ismember(ages_to_use, age_vector);
    idxs_to_out = loc(idx);
    lens_densities_to_plot = lensDensity_template_LOG(:, idxs_to_out);
    
    %% Convert LOG Density to LINEAR Transmittance
    log_transmittances = -1 * lens_densities_to_plot;
    linear_transmittances = 10 .^ log_transmittances;
        
    %%
    scr = get(0,'ScreenSize');    
    fig = figure('Color', 'w', 'Name', 'Lens density vs Transmittance');
    set(fig, 'Position', [0.1*scr(3) 0.55*scr(4) 0.8*scr(3) 0.35*scr(4)])
        
    legend_str = cell(length(ages_to_use),1);
    for l = 1 : length(ages_to_use)
        legend_str{l} = [num2str(ages_to_use(l)), ' yrs']; 
    end
    
    rows = 1; cols = 2; i = 0;
    peak_wavelengths = [400 600];
    
    i = i + 1;
    sp(i) = subplot(rows, cols, i);
    p(:,i) = plot(lambda, lens_densities_to_plot);
    t(i) = title('LOG Ocular Media Density');
    xL(i) = xlabel('Wavelength [nm]');
    yL(i) = ylabel('Optical Density [OD]');
    leg(i) = legend(p(:,i), legend_str, 'Interpreter', 'none', 'Location', 'NorthEast');
        legend('boxoff')
        
        % NOTE! if "Warning: Error updating Legend. not enough input, run
        % "rehash toolboxcache" and we get conflicts from SPM 12
        % arguments", there is a funky conflict with narginchk apparently?
        % Remove from path all the external/fieldtrip/compat paths
        % https://uk.mathworks.com/matlabcentral/answers/373117-why-do-i-get-an-error-updating-legend-in-matlab-2017b
        % https://uk.mathworks.com/matlabcentral/answers/427286-why-am-i-getting-these-plot-warnings
        
    i = i + 1;
    sp(i) = subplot(rows, cols, i);
    p(:,i) = plot(lambda, 100*linear_transmittances);
    t(i) = title('Linear Ocular Media Transmittance');
    xL(i) = xlabel('Wavelength [nm]');
    yL(i) = ylabel('Transmittance [%]');
    leg(i) = legend(p(:,i), legend_str, 'Interpreter', 'none', 'Location', 'SouthEast');
        legend('boxoff')
        
    set(sp, 'XLim', peak_wavelengths)
    set(p, 'LineWidth', 2)
    
    % style here
    set(sp, 'FontName','NeueHaasGroteskDisp Pro', 'FontSize', 8)
    set([t xL yL], 'FontName','NeueHaasGroteskDisp Pro', 'FontSize', 10)

end