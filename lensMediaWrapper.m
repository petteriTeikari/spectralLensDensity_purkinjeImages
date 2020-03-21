function [l, lens_density_log, lens_transmittance_log] = lensMediaWrapper(age, nm_resolution, plot_ON, l, offset)

    if nargin == 1
        nm_resolution = 0.1;        
    end

    if nargin == 2
        plot_ON = false;
    end

    % TODO! check these as Matlab does not allow keyword arguments
    if nargin < 5
        % NOTE! this is called within "sensitivity_analysis_wrapper.m"
        % thus easier to keep these "hard-coded" here in current
        % implementation of the code
        min_nm = 300;
        max_nm = 700;
        n = int64(1 + ((max_nm - min_nm) / nm_resolution));
        l = linspace(min_nm, max_nm, n)';        
        offset = 0.111; % offset density for long wavelengths
    end
    
    % This is a structure with the subcomponents as fields
    lens_struct = lensModel_vanDeKraats2007(age, l, offset);
    
    % We now use just the sum, but you could individually plot the
    % components if you wanted
    lens_density_log = lens_struct.totalMedia;
    lens_density_linear = 10 .^ lens_density_log;
    
    % Density -> Transmittance
    lens_transmittance_log =  (lens_density_log * -1);
    lens_transmittance_linear = 10 .^ lens_transmittance_log;
    
    if plot_ON
       rows = 2; cols = 2; i = 0;
       i = i+1; sp(i) = subplot(rows, cols, i); plot(l, lens_density_linear); title(['Density Linear, age = ', num2str(age)])
       i = i+1; sp(i) = subplot(rows, cols, i); plot(l, lens_density_log); title(['Density LOG, age = ', num2str(age)])
       i = i+1; sp(i) = subplot(rows, cols, i); plot(l, lens_transmittance_linear); title(['Transmittance Linear, age = ', num2str(age)])
       i = i+1; sp(i) = subplot(rows, cols, i); plot(l, lens_transmittance_log); title(['Transmittance LOG, age = ', num2str(age)])
       set(sp, 'XLim', [min(l) max(l)])
    end
    

end