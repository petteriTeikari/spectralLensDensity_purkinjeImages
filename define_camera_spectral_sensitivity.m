function [camera_sensitivity, camera_metadata] = define_camera_spectral_sensitivity(model, lambda, output_in_photons, plot_ON)

    disp('3) Defining camera quantum efficiency and other useful metadata')

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
    
    %%
    if strcmp(model, 'FLIR-Blackfly-S-USB3')
        
        % This camera is using "Sony IMX252" CMOS sensor
        % Note this is graphically extracted from the ImagingSource image
        % so might have some uncertainty itself        
        need_to_extrapolate = false;          
        if need_to_extrapolate
            fname = 'imagingSource_page_of_IMX252_monoSensitivity_toExtract_400-1000nm_spectrum.txt';
        else
            fname = 'FLIR-Blackfly-S-USB3_BFS-U3-32S4M-C_Sony_IMX252_quantumEfficiency.csv';
        end
        sensitivity_raw = importdata(fullfile(cameraData_folder, fname));
        [camera_sensitivity, camera_metadata] = interpolate_sensitivity_to_lambda_vector(lambda, sensitivity_raw, model, ...
                                                                                          need_to_extrapolate, plot_ON, ...
                                                                                          cameraData_folder);            
    else
        
       warning('We have defined only FLIR Blackfly BFS-U3-32S4M-C! You need to add your camera!')
       
       % If you are one of the millions of people wanting to do Purkinje
       % Image-based ocular media density estimation, you could have a look
       % of these camera models as well. You are measuring the ratios
       % between two intensities so you would like to have high dynamic
       % range way beyond the "consumer 8-bit".
       
       % Although this Purkinje Image-based system in practice makes the most 
       % sense when implemented as very low-cost, then the expensive camera
       % is hard to justify beyond optical bench "gold standarding"
       
       % So in the end you might want to have a low-cost camera that you
       % could use in "HDR mode" (as in quickly acquire successive frames
       % with different exposure times) and add some computational imaging
       % post-processing to it?
       
       % 1)
       % pco.edge 4.2 : "The pco.edge 4.2 camera system is designed for users who require highest quantum efficiency, 
       % best 16 bit dynamic range, high frame rates, long exposure times and extremely low readout noise."
       % https://www.pco.de/scientific-cameras/pcoedge-42/ 
       % with similar quantum efficiency curve as in IMX252
       % for Python interfacing see e.g. https://github.com/AndrewGYork/tools/blob/master/pco.py
       
       % 2)
       % Some MIPI CSI option if you are looking to build an embedded
       % system with the computational power from NVIDIA Jetson TX2 /
       % Nano / Xavier NX. 
       
       % you can use the Raspberry Pi Camera on NVIDIA, e.g.
       % https://github.com/JetsonHacksNano/CSI-Camera
       
       % See e.g. e-con Systems
       % https://www.e-consystems.com/nvidia-jetson-camera.asp
       % Leopard: https://leopardimaging.com/product-category/nvidia-jetson-cameras/nvidia-tx1tx2-mipi-camera-kits/
       % Allied Vision: https://www.vision-systems.com/embedded/article/14072478/allied-vision-releases-free-mipi-driver-for-nvidia-jetson-tx2
       % Imaging Source: https://www.theimagingsource.com/campaigns/mipi-csi-2-fpd-link-iii-modules/
       
       % 3)
       % Santos et al. (2018) used 14-bit EMCCD from Andor's Luca camera family
       % see e.g. https://andor.oxinst.com/learning/view/article/electron-multiplying-ccd-cameras
       % https://andor.oxinst.com/?seriesid=59&Page=cameradetails

       % 4) 
       % Low-cost Raspberry Pi -type camera with Sony IMX219?
       % Plug-in some Google Coral / Intel® Neural Compute Stick
       % https://khufkens.github.io/pi-camera-response-curves/
       
       % Pagnutti et al. (2017): "Laying the foundation to use Raspberry Pi
       % 3 V2 camera module imagery for scientific and engineering purposes"
       % https://doi.org/10.1117/1.JEI.26.1.013014
       
       % Wilkes et al. (2016): "Ultraviolet Imaging with Low Cost Smartphone Sensors: 
       % Development and Application of a Raspberry Pi-Based UV Camera
       % https://doi.org/10.3390/s16101649
       
       % The PiSpec: A Low-Cost, 3D-Printed Spectrometer for Measuring Volcanic SO2 Emission Rates
       % https://doi.org/10.3389/feart.2019.00065
        
       % Flat-field and colour correction for the Raspberry Pi camera
       % module (2019) https://arxiv.org/abs/1911.13295
       
       % SEE ALSO:
       % Standardized spectral and radiometric calibration of consumer cameras
       % https://doi.org/10.1364/OE.27.019075
       
       % Developing a spectral pipeline using open source software 
       % and low-cost hardware for material identification
       % https://doi.org/10.1080/01431161.2019.1693075      
       
    end
        
    camera_sensitivity_E = convert_fromQuantaToEnergy(camera_sensitivity, lambda);
    camera_sensitivity_E = camera_sensitivity_E ./ max(camera_sensitivity_E); % normalizes
        
    
    if plot_ON
        
        scr = get(0,'ScreenSize');    
        fig = figure('Color', 'w', 'Name', 'Camera Sensitivity');
        set(fig, 'Position', [0.1*scr(3) 0.55*scr(4) 0.8*scr(3) 0.35*scr(4)])
        
        i = 0; rows = 1; cols = 2;
        
        i = i + 1; sp(i) = subplot(rows, cols, i); p(i) = plot(lambda, camera_sensitivity);
        t(i) = title('FLIR-Blackfly-S-USB3_BFS-U3-32S4M-C [Sony_IMX252] Quantum Efficiency', 'Interpreter', 'none');
        xL(i) = xlabel('Wavelength [nm]');
        yL(i) = ylabel('Normalized Quantum Efficiency');    
        
        i = i + 1; sp(i) = subplot(rows, cols, i); p(i) = plot(lambda, camera_sensitivity_E);
        t(i) = title('FLIR-Blackfly-S-USB3_BFS-U3-32S4M-C [Sony_IMX252] "Irradiance Sensitivity"', 'Interpreter', 'none');
        xL(i) = xlabel('Wavelength [nm]');
        yL(i) = ylabel('Normalized Spectral Sensitivity');    
                
        set(p, 'LineWidth', 2)
        set(sp, 'XLim', [min(lambda), max(lambda)], 'YLim', [0 1.05])        
        set(sp, 'FontName','NeueHaasGroteskDisp Pro', 'FontSize', 8)
        set([t xL yL], 'FontName','NeueHaasGroteskDisp Pro', 'FontSize', 10)
    end
    

end


function [camera_sensitivity, camera_metadata] = interpolate_sensitivity_to_lambda_vector(lambda, sensitivity_raw, model, ...
                                                                                          need_to_extrapolate, plot_ON, ...
                                                                                          cameraData_folder)

    lambda_raw = sensitivity_raw(:,1);
    norm_response_raw = sensitivity_raw(:,2);
    
    if strcmp(model, 'FLIR-Blackfly-S-USB3')
        
        % TODO! import some camera metadata
        camera_metadata.dummy = NaN;
       
        if need_to_extrapolate
            
            disp('    ... extrapolating the quantum efficiency to have some short wavelength sensitivity')
            
            % match the wavelength vectors first
            sensitivity_out = zeros(length(lambda),1);
            sensitivity_out(:) = NaN;
    
            [idx,loc] = ismember(lambda_raw,lambda);
            idxs_to_out = loc(idx);
    
            [idx,loc] = ismember(lambda, lambda_raw);
            idxs_from_raw = loc(idx);
    
            sensitivity_out(idxs_to_out) = norm_response_raw(idxs_from_raw);    
            
            % manual fix based on the "FLIR_quantumEfficiency_CCD_vs_CMOS.png"        
            lambda_1 = 300;
            lambda_2 = 315;
            lambda_3 = 340;
            lambda_4 = 380;
            sensitivity_out(lambda == lambda_1) = 0.05;
            sensitivity_out(lambda == lambda_2) = 0.04;
            sensitivity_out(lambda == lambda_3) = 0.1;
            sensitivity_out(lambda == lambda_4) = 0.4;

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
            
            % manual concatenation 
            short = [lambda(1:103) camera_sensitivity(1:103)];
            full = [short; sensitivity_raw];
            dlmwrite(fullfile(cameraData_folder, 'FLIR-Blackfly-S-USB3_BFS-U3-32S4M-C_Sony_IMX252_quantumEfficiency.csv'), ...
                     full)
            
        else
            
            disp('    ... interpolating the already extrapolated (300-1000nm) quantum efficiency to simulation wavelength resolution')
            camera_sensitivity = interp1(lambda_raw, norm_response_raw, lambda, 'pchip');
            
             if plot_ON
                rows = 1; cols = 2; i = 0;
                i = i + 1; sp(i) = subplot(rows, cols, i); plot(lambda_raw, norm_response_raw); 
                           title(['NonNan, no of samples = ', num2str(length(lambda_raw))])
                i = i + 1; sp(i) = subplot(rows, cols, i); plot(lambda, camera_sensitivity);
                           title(['Interpolated, no of samples = ', num2str(length(lambda))])
                
                
            end        
            
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
