function setup_trace_vs_space
%SETUP_TRACE_VS_SPACE Add this manuscript repository to the MATLAB path.

rootDir = char(fileparts(mfilename('fullpath')));
if isempty(rootDir) || ~isfolder(rootDir)
    error('trace_vs_space:SetupRoot', ...
        'Could not determine the trace_vs_space repository root.');
end

addpath(rootDir);
addpath([rootDir filesep 'eyeblink']);
addpath([rootDir filesep 'include']);

requiredProducts = { ...
    'MATLAB', ...
    'Image Processing Toolbox', ...
    'Statistics and Machine Learning Toolbox', ...
    'Parallel Computing Toolbox'};
installedProducts = ver;
installed = {installedProducts.Name};
missing = requiredProducts(~ismember(requiredProducts, installed));

if isempty(missing)
    fprintf('trace_vs_space paths added. Required MathWorks products were found.\n');
else
    warning('trace_vs_space:MissingProducts', ...
        'Missing MathWorks products: %s', strjoin(missing, ', '));
end
end
