% Contains user defined meta data for the netcdf file(s)
% produced. The name of this file needs to correspond
% to the filename given in the config_***.m file
%
% Meta data required for the AC3 ouput files.


% height above mean sea level [m] of the instrument platform
%   stored in the metadata 
config.MSL = 22;


% % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Standard global attributes following the CF convention (descriptions from CF documentation)
config.conventions = 'CF-1.10';

% "A succinct description of what is in the dataset."
config.title = {'MiRAC-A measurements on RV Polaratern', ...
                'Doppler spectra for MiRAC-A measurements on RV Polarstern', ...
                'Housekeeping data for MiRAC-A measurements on RV Polarstern'};

% "Provides an audit trail for modifications to the original data. Well-behaved generic netCDF filters will automatically append their name and the parameters with which they were invoked to the global history attribute of an input netCDF file. We recommend that each line begin with a timestamp indicating the date and time of day that the program was executed."
config.history  = [datestr(now) ': Lv1 file generated from binary lv0 file using processing_script'];

% "Specifies where the original data was produced."
config.institution = 'University of Cologne, Germany';

% "The method of production of the original data."
config.source = 'MiRAC-A cloud radar';%'RPG-FMCW-94-SP';

% "Miscellaneous information about the data or methods used to produce it."
% separate comments for each of the three files, 
config.comment = {'This file contains radar moments and the most important parameters needed to analyze the data. Doppler spectra and full housekeeping data are stored in separate files.', ... % moments file
                  'The Doppler spectra has gone through a dealiasing algorithm, for details see references. This file only contains the radar Doppler spectra and associated parameters. Further radar variables and full housekeeping data are stored in separate files.', ... % spectra file
                  'This file only contains housekeeping data, 89 GHz brightness temperature and derived products, and weather station measurements. Main radar variables are stored in separate files.'};    % housekeeping file

% "Published or web-based references that describe the data or methods used to produce it."
config.references  = 'Gierens et al., in preparation for ESSD; Küchler et al. (2017) https://doi.org/10.1175/JTECH-D-17-0019.1; Mech et al. (2019) https://doi.org/10.5194/amt-12-5019-2019'; % mirac also Mech et al


% % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Other meta data

% Name of the processing script
config.processing_script = 'https://github.com/igmk/w-radar/releases/tag/v202305';

config.featureType = 'timeSeriesProfile';

config.pi          = 'Kerstin Ebell; University of Cologne, Germany; kerstin.ebell@uni-koeln.de';       
config.author      = 'Andreas Walbroel; University of Cologne, Germany; a.walbroel@uni-koeln.de';       
config.project     = '(AC)3';

config.license     = 'CC-BY 4.0';
