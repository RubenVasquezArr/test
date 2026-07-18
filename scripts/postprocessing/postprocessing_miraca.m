function [data, info] = postprocessing_miraca(data, info)
% corrections to radar data that are done after all the other processing
% took place


%% clean data potentially affected by artificial spikes
if isfield(data, 'lineart_flag')

    data.vm(data.lineart_flag) = NaN;
    data.sigma(data.lineart_flag) = NaN;
    data.skew(data.lineart_flag) = NaN;
    data.kurt(data.lineart_flag) = NaN;
    
end
