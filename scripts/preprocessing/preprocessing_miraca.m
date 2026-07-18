function [data, info] = preprocessing_miraca(data, info, ~)

%% ################ add metadata

if strcmp(info.nickstation, 'nya')
    %Height
    data.MSL = 11.;  

elseif strcmp(info.nickstation, 'pol')
    %Height
    data.MSL = 22.;
    
else
    disp('unknown station')

end

% add info on software version to dataset - only done for Ny-Ålesund

if data.time(1) < datetimeconv(2018,03,19,14,30,0) % did not document time of software update precisely, could be that slightly later - RG 16.9.2022
    data.radarsw = '2';
    
elseif datetimeconv(2018,03,19,14,30,0) <= data.time(1) && data.time(1) < datetimeconv(2018,10,10,0,0,0)
    data.radarsw = '3.80';
    
elseif datetimeconv(2022,06,01,0,0,0) <= data.time(1) && data.time(1) < datetimeconv(2022,09,16,08,15,0)
    data.radarsw = '5.61 (5.59)';    
    
elseif datetimeconv(2022,09,16,08,15,0) <= data.time(1) && data.time(1) < datetimeconv(2023,04,01,0,0,0) % guess date for when mirac-a installation at nya over
    data.radarsw = '5.61';    
   
elseif datetimeconv(2024,08,10,0,0,0) <= data.time(1) && data.time(1) < datetimeconv(2024,10,09,0,0,0) % VAMPIRE
    data.radarsw = '5.61';

elseif datetimeconv(2025,07,02,0,0,0) <= data.time(1) && data.time(1) < datetimeconv(2025,09,01,0,0,0) % VAMPIRE-2
    data.radarsw = '5.63';

elseif datetimeconv(2026,03,01,0,0,0) <= data.time(1) && data.time(1) < datetimeconv(2026,04,20,0,0,0) % COMPEX
    data.radarsw = '5.63';

elseif datetimeconv(2026,06,22,0,0,0) <= data.time(1)
    data.radarsw = '5.63';

else    
    disp('From function processing_miraca: Radar software version not defined!')
    
end % if


%% ####################### clean data from artificial spikes

% data was collected in NyA
if datetimeconv(2017,1,1) < data.time(1) && data.time(1) < datetimeconv(2017,12,1) 
    
    data.lineart_flag = false(size(data.range));
    
    if isfield(data, 'spec')

        ss = size(data.spec);
        if ss(2) == 765 % then it is the high res mode
            spec = squeeze(data.spec(:,:,1))';

            % indicates artificial spikes that occur at well know range gates
            % cont_mat is true for all gates where only artifact found
            % if the problem is within a cloud, the spectra is not cleared
            % but the data is removeed in postprocessing
            cont_mat = spike_filter(spec, 664, 665)...
                        | spike_filter(spec, 675, 675)...
                        | spike_filter(spec, 709, 710);
            
            % clear spectra with contamination
            for ii = 1:ss(1)
                data.spec(ii,cont_mat(:,ii),:) = NaN;
            end
        end % if ss(1)
        
    else
        disp('Did not remove artefacts from reflectivity')
    end
    
    % flag range gates known to contain artificial spikes
    data.lineart_flag([664:665, 675, 709:710]) = true;
   
elseif datetimeconv(2017,12,1) <= data.time(1) && data.time(1) < datetimeconv(2018,11,1)
    
    data.lineart_flag = false(size(data.range));
    if isfield(data, 'spec')

        ss = size(data.spec);
        if ss(2) == 765 % then it is the high res mode
            spec = squeeze(data.spec(:,:,1))';

            % indicates artificial spikes that occur at well know range gates
            % cont_mat is true for all gates where only artifact found
            % if the problem is within a cloud, the spectra is not cleared
            % but the data is removeed in postprocessing
            cont_mat = spike_filter(spec, 665, 665);
            
            % clear spectra with contamination
            for ii = 1:ss(1)
                data.spec(ii,cont_mat(:,ii),:) = NaN;
            end
        end % if ss(1)
        
    else
        disp('Did not remove artefacts from reflectivity')
    end
    
    % flag range gates known to contain artificial spikes
    data.lineart_flag([665]) = true;
    
end


%% ######## Ze corrections

% Before radar software version 5.0 need to correct for incorrectly 
% estimated receiver gain: factor of 2/adding +3 dB.

% NOTE! not sure when software was updated (no logs), assuming problem
% existed until the end of measurements at nya

if data.time(1) < datetimeconv(2018,10,10)
    % 560822400 corresponds to 2018, October 10th (end of measurements at nya)
    
    data.spec = data.spec*2; % Ze in linear units, this is same as adding 3 dB in log scale
                         % data.Ze*2 = 10^( (10.*log10(data.Ze) + 3)/10 )

    data.Ze_label = 'Ze corrected with +3dB (to correct for receiver gain).';
    data.Ze_corr = 3;
end


    
