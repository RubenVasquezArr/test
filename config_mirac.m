% Configuration file to run data processing for mirac-a,
% used for running reprocessing of data in winter 2022/23.
%
% -------------------------------------------------------------------------
% Settings configuration file
%--------------------------------------------------------------------------


setenv('LC_ALL','C')

% define inpput data path - structer in selected folder should be
%                           /yyyy/mm/dd/file-type
config.datapath = '/data/obs/site/nya/mirac-a/l0';


% select input-file-type
%   needs to be a case sensitive match to the file name
%config.filetype = '*nc'; % (older version)
config.filetype = '*lv0'; % (newer version)


% define output path - folder structure will be: /yyyy/mm/dd/*.nc
config.outputpath = '/data/obs/site/nya/mirac-a/l1';



% Give type of output: use one of the provided options or add your own.
config.outputtype = 'ac3';

% All user provided metadata has been moved from this config file to another
% file - give filename here. Does not need to match with config.outputtype.
config.metadatafile = 'outputmeta_miraca_ac3';

% Tag added to the file name
config.filetag = 'lv1a' ;

% Instrument nickname:
% - apears in the output file name
% - name has to match the possible preprocessing and postprocessing matlab-
%   function file names
config.nickradar = 'mirac-a';

% Station nick name (used for file naming):
% - naming convention to use: 3 letters refering to the station measured
%   example: JOYCE = joy
config.nickstation = 'nya';

% Debuging option
% 0 - no debugging information given, code does not crash
% 1 - makes check plot in dealising, enables debugging of some functions
config.debuging = 0;

%Overwrite existing data
% 0 - if output file(s) already exist, no data processing is done
% 1 - overwrite (existing) output file(s)
config.overwrite = 0; 

%Dealias:
% true - dealiasing is applied
% false - dealiasing not appleied
config.dealias = true;

%Speckle filter (optional):
% 0 - no speckle filtering applied
% 1 - simple speckle removal in time-height space
config.speckle = 1;

% moments_cal:
% Note! at the moment (July 2019), only use 2!
% 2 - means spectral moments will be calculated (runs momentslv0-function)
% 3 - means moments are taken from files lv1 if available, (runs momentslv1-function, in 201907 not working)
config.moments2calculate = 2;


% option to use time stamp from lv1 file, if issues in lv0 time found
config.timefromlv1 = 0;
config.filetype_lv1 = 'lv1';
