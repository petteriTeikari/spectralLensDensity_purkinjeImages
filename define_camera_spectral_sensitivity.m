function camera_sensitivity = define_camera_spectral_sensitivity(model, lambda, output_in_photons, plot_ON)

    if nargin == 2
        output_in_photons = true;
        plot_ON = false;
    end

    if nargin == 3
        plot_ON = false;
    end
    
    currentFolder = mfilename('fullpath');
    currentFolder = strrep(currentFolder, 'define_camera_spectral_sensitivity', '');
    cameraData_folder = fullfile(currentFolder, 'cameraData');

    % If you are looking to buy your own camera, you could have a look of
    % the nice list by ImagingSource with spectral sensitivities listed 
    % for various industrial cameras (note that the shown range is 
    % from 400 -> 1000 nm )
    % https://s1-dl.theimagingsource.com/api/2.5/packages/publications/whitepapers-cameras/wpspectsens/9f5ebc13-5279-5891-871b-888862af5cb8/wpspectsens_1.30.en_US.pdf
    
    % Relative sensitivity is still at 50% at 400 nm, and we can make a
    % guestimate based on "FLIR_quantumEfficiency_CCD_vs_CMOS.png" from
    % https://www.flir.eu/support-center/iis/machine-vision/whitepaper/sony-pregius-global-shutter-cmos-imaging-performance/
    % how the sensitivity will go down between 300-400 nm

    % You can see for example that the 2nd gen Sony Pregius have broadening
    % of the spectral sensitivity with reduced sensitivity on lower
    % wavelengths (e.g. IMX174 vs IMX264)
    % http://image-sensors-world.blogspot.com/2018/04/
    
    % With some CCD having lower quantum efficiency than CMOS
    % https://www.flir.eu/support-center/iis/machine-vision/whitepaper/sony-pregius-global-shutter-cmos-imaging-performance/
    
    % And if you do not really understand the camera terms, you could have
    % a look the document from FLIR:
    % "SENSOR REVIEW: MONO CAMERAS"
    % https://www.flir.com/globalassets/iis/guidebooks/2019-machine-vision-emva1288-sensor-review.pdf
    
    if strcmp(model, 'FLIR-Blackfly-S-USB3')
        % This camera is using "Sony IMX252" CMOS sensor
        % Note this is graphically extracted from the ImagingSource image
        % so might have some uncertainty itself
        fname = 'imagingSource_page_of_IMX252_monoSensitivity_toExtract_400-1000nm_spectrum.txt';
        sensitivity_raw = importdata(fullfile(cameraData_folder, fname));
        camera_sensitivity = interpolate_sensitivity_to_lambda_vector(lambda, sensitivity_raw, model, plot_ON);        
    else
       warning('We have defined only FLIR Blackfly BFS-U3-32S4M-C! You need to add your camera')
    end
    
    if output_in_photons
        camera_sensitivity = convert_fromQuantaToEnergy(camera_sensitivity, lambda);
        camera_sensitivity = camera_sensitivity ./ max(camera_sensitivity);
    end
    
    disp('3) Spectral Quantum Efficiency of the camera defined')

end


function camera_sensitivity = interpolate_sensitivity_to_lambda_vector(lambda, sensitivity_raw, model, plot_ON)

    lambda_raw = sensitivity_raw(:,1);
    norm_response_raw = sensitivity_raw(:,2);
    
    % match the wavelength vectors first
    sensitivity_out = zeros(length(lambda),1);
    sensitivity_out(:) = NaN;
    
    [idx,loc] = ismember(lambda_raw,lambda);
    idxs_to_out = loc(idx);
    
    [idx,loc] = ismember(lambda, lambda_raw);
    idxs_from_raw = loc(idx);
    
    sensitivity_out(idxs_to_out) = norm_response_raw(idxs_from_raw);    
    
    if strcmp(model, 'FLIR-Blackfly-S-USB3')
       
        % manual fix based on the "FLIR_quantumEfficiency_CCD_vs_CMOS.png"        
        sensitivity_out(1) = 0.4;        
        
        % interpolate the missing values as we have put the endpoint above
        nan_idx = isnan(sensitivity_out);
        lambda_non_nan = lambda(~nan_idx);
        sensitivity_no_nan = sensitivity_out(~nan_idx);                
        camera_sensitivity = interp1(lambda_non_nan, sensitivity_no_nan, lambda, 'pchip');
        
        if plot_ON
            rows = 1; cols = 2; i = 0;
            i = i + 1; sp(i) = subplot(rows, cols, i); plot(lambda_non_nan, sensitivity_no_nan); 
                       title(['NonNan, no of samples = ', num2str(length(lambda_non_nan))])
            i = i + 1; sp(i) = subplot(rows, cols, i); plot(lambda, camera_sensitivity);
                       title(['Interpolated, no of samples = ', num2str(length(lambda))])
            set(sp, 'XLim', [min(lambda), max(lambda)])
        end        
        
    end
        
    
end

function Q = convert_fromEnergyToQuanta(E, lambda)
     
    % Inputs
     %      E       - Irradiance [W/cm^2/sec (/nm)]
     %      lambda  - Wavelength [nm]
     % Output
     %      Q       - Photon density [ph/cm^2/sec]       
     
     h = 6.62606896 * 10^-34; % Planck's constant [J*s]
     c = 299792458; % Speed of light [m/s]  
     photonEnergy_vector = (h * c) ./ (lambda * 10^-9); % [J]
     Q = E ./ photonEnergy_vector;      
     
end
     
function E = convert_fromQuantaToEnergy(Q, lambda)
     
     % Inputs
     %      Q       - Photon density [ph/cm^2/sec]
     %      lambda  - Wavelength [nm]
     % Output
     %      E       - Irradiance [W/cm^2/sec (/nm)]
     
     h = 6.62606896 * 10^-34; % Planck's constant [J*s]
     c = 299792458; % Speed of light [m/s]  
     photonEnergy_vector = (h * c) ./ (lambda * 10^-9); % [J]   
     E = Q .*  photonEnergy_vector;
     
end