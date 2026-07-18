function [data, config] = preprocessing_joyrad94(data, config, lv0filetype)


%% ########### give station specific parameters

% time in sec since 2001,1,1,0,0,0
if datetimeconv(2018,03,01) < data.time(1) && data.time(1) < datetimeconv(2019,01,31) % data was collected in Iqq
    % 541555200 corresponds to 2018, March 1st
    % 570585600 corresponds to 2019, January 31st    

    %Height
    data.MSL = 56;

elseif (datetimeconv(2016,06,01) < data.time(1) && data.time(1) < datetimeconv(2017,08,01)) ... % data was collected in NyA
        || ( datetimeconv(2019,06,01) < data.time(1) && data.time(1) < datetimeconv(2022,07,01))
    % 486432000 corresponds to 2016, June, 1st, and 523238400 to 2017, August 1st
    % 581040000 corresponds to 2019, June, 1st

    %Height
    data.MSL = 11.;  

else % joyce
    
    %Height
    data.MSL =  111. + 19.5 + 1; % height above sea level + height of platform above ground + height of dish above platform   
end


%% ################ add info on software version to dataset
if data.time(1) < datetimeconv(2017,02,07,15,0,0)
    data.radarsw = '1.00';
    
elseif datetimeconv(2017,02,07,15,0,0) <= data.time(1) && data.time(1) < datetimeconv(2017,07,27,0,0,0)
    data.radarsw = '2.10';
    
elseif datetimeconv(2018,03,21,0,0,0) <= data.time(1) && data.time(1) < datetimeconv(2019,01,26,0,0,0)
    data.radarsw = '3.80';    

elseif datetimeconv(2019,06,12,0,0,0) <= data.time(1) && data.time(1) < datetimeconv(2019,11,28,13,30,0)
    data.radarsw = '5.11';    
    
elseif datetimeconv(2019,11,28,13,30,0) <= data.time(1) 
    data.radarsw = '5.25';    
else
    disp('From function processing_joyrad94: Radar software version not defined!')
    
end % if


%% edit chirp program name

% chirp program was changed, but the name wasn't 
if (datetimeconv(2023,03,07,10,45,0) < data.time(1)) && strcmp(data.progname(1:end-1), 'High Res old')
    data.progname = 'High Res old 03.2023';
end

%% ####################### clean data from artificial spikes
if lv0filetype == 2
    
    data.lineart_flag = false(size(data.range));
    
    if isfield(data, 'spec')

        ss = size(data.spec);
        if ss(2) == 1021 % then it is the high res mode
            spec = squeeze(data.spec(:,:,1))';

            % indicates artificial spikes that occur at well know range gates
            % cont_mat is true for all gates where only artifact found
            % if the problem is within a cloud, the spectra is not cleared
            % but the data is removeed in postprocessing
            cont_mat = spike_filter(spec, 224, 224) | spike_filter(spec, 765, 766);
            
%             cont_mat = spike_filter_joy94_high_res_mode_v2(spec); %

            % clear spectra with contamination
            for ii = 1:ss(1)
                data.spec(ii,cont_mat(:,ii),:) = NaN;
            end
        end % if ss(1)
        
    else
        disp('Did not remove artefacts from reflectivity')
    end
    
    % flag range gates known to contain artificial spikes
    data.lineart_flag([224, 765, 766]) = true;
        
end % if software



%% ############ Ze corrections

% Before radar software version 5.0 need to correct for incorrectly 
% estimated receiver gain: factor of 2/adding +3 dB.

% NOTE! not sure when software was updated (no logs), assuming problem
% existed until the end of measurements at iqq. The software version 
% was 3 at least until July 10, 2018

if data.time(1) < datetimeconv(2019,01,31)
    % 570585600 corresponds to 2019, January 31st (end of measurements at iqq)
   
    data.spec = data.spec*2; % Ze in linear units, this is same as adding 3 dB in log scale
                         % data.Ze*2 = 10^( (10.*log10(data.Ze) + 3)/10 )

    data.Ze_label = 'Ze corrected with +3dB (to correct for receiver gain).';

    data.Ze_corr = 3; % 
    
end


% Originally theoretical values for antenna gain and beam width used, but
% later calibrations found these values where slightly off: Reflectivity
% undersestimted by a factor of 1.466 (1.66dB)

test1 = round(double(data.HPBW),2) == 0.48;
test2 = round(double(data.AntG),-1) == 144540;

if test1 && test2
    
    if ~isfield(data, 'Ze_label')
        data.Ze_corr = 1.66;
        data.Ze_label = 'Ze corrected with +1.66 dB (to correct for antenna gain and beam width)';
    end
    
    data.spec = data.spec*1.466;
    data.Ze_label = [data.Ze_label ' Ze corrected with +1.66 dB (to correct for antenna gain and beam width).'];
    data.Ze_corr = data.Ze_corr + 1.66;
    
elseif (test1 && ~test2) || (~test1 && test2)
    disp('WARNING! Unexpexted radar configuration.')
end

    
