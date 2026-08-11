function summary = run_demo(outputDir)
%RUN_DEMO Run the Nature-checklist demonstration on one real session.
%
%   summary = run_demo
%   summary = run_demo(outputDir)
%
% The demo loads rat0314 session 2023-05-22, plots the Figure 2 example
% neuron (cell 44), saves a PNG, and writes a MAT-file containing validation
% values and elapsed runtime.

rootDir = char(fileparts(mfilename('fullpath')));
if nargin < 1 || isempty(outputDir)
    outputDir = [rootDir filesep 'outputs' filesep 'demo'];
else
    outputDir = char(outputDir);
end

dataFile = [rootDir filesep 'demo_data' filesep 'rat314sample.mat'];
assert(isfile(dataFile), 'trace_vs_space:MissingDemoData', ...
    'Demo data not found: %s', dataFile);

loaded = load(dataFile, 'rat314sample');
assert(isfield(loaded, 'rat314sample'), ...
    'trace_vs_space:MissingDemoVariable', ...
    'The demo file must contain a variable named rat314sample.');
rat = loaded.rat314sample;

day = '2023_05_22';
peakField = ['CA_peaks_' day];
csField = ['CS_' day];
posField = ['pos_' day];

assert(isfield(rat, 'Ca_peaks') && isfield(rat.Ca_peaks, peakField), ...
    'trace_vs_space:MissingDemoField', 'Missing rat314sample.Ca_peaks.%s.', peakField);
assert(isfield(rat, 'CS_times') && isfield(rat.CS_times, csField), ...
    'trace_vs_space:MissingDemoField', 'Missing rat314sample.CS_times.%s.', csField);
assert(isfield(rat, 'pos') && isfield(rat.pos, posField), ...
    'trace_vs_space:MissingDemoField', 'Missing rat314sample.pos.%s.', posField);

peaks = rat.Ca_peaks.(peakField);
csTimes = rat.CS_times.(csField);
pos = rat.pos.(posField);
cellIndex = 44;

assert(isnumeric(peaks) && size(peaks, 1) >= cellIndex, ...
    'trace_vs_space:InvalidDemoPeaks', ...
    'Ca_peaks must be numeric with at least %d rows.', cellIndex);
assert(isnumeric(csTimes) && ~isempty(csTimes), ...
    'trace_vs_space:InvalidDemoCS', 'CS times must be a nonempty numeric vector.');
assert(isnumeric(pos) && size(pos, 2) >= 3, ...
    'trace_vs_space:InvalidDemoPosition', ...
    'Position data must be numeric with [time, x, y] columns.');

if ~isfolder(outputDir)
    mkdir(outputDir);
end

started = tic;
plotTrialRastersWithSpeed(peaks, csTimes, [-1 2], pos, cellIndex);
fig = gcf;
drawnow;

pngFile = [outputDir filesep 'rat0314_2023_05_22_cell44_demo.png'];
exportgraphics(fig, pngFile, 'Resolution', 150);
elapsedSeconds = toc(started);

axesHandles = findall(fig, 'Type', 'axes');
cellEvents = peaks(cellIndex, :);
cellEvents = cellEvents(isfinite(cellEvents) & cellEvents > 0);

summary = struct();
summary.animal = 'rat0314';
summary.session = day;
summary.cellIndex = cellIndex;
summary.nCells = size(peaks, 1);
summary.nTrials = numel(csTimes);
summary.nCellEvents = numel(cellEvents);
summary.nPlotAxes = numel(axesHandles);
summary.elapsedSeconds = elapsedSeconds;
summary.outputPng = pngFile;

assert(summary.nTrials == 50, 'trace_vs_space:UnexpectedTrialCount', ...
    'Expected 50 demo trials; found %d.', summary.nTrials);
assert(summary.nPlotAxes == 3, 'trace_vs_space:UnexpectedAxesCount', ...
    'Expected three plot axes; found %d.', summary.nPlotAxes);
assert(isfile(pngFile), 'trace_vs_space:MissingDemoOutput', ...
    'Expected output was not created: %s', pngFile);

summaryFile = [outputDir filesep 'rat0314_2023_05_22_cell44_demo_summary.mat'];
summary.outputSummary = summaryFile;
save(summaryFile, 'summary');

fprintf(['Demo complete: %d cells, %d trials, %d events for cell %d, ' ...
    '%d axes, %.3f s.\n'], summary.nCells, summary.nTrials, ...
    summary.nCellEvents, summary.cellIndex, summary.nPlotAxes, ...
    summary.elapsedSeconds);
fprintf('Saved figure: %s\n', pngFile);
fprintf('Saved summary: %s\n', summaryFile);
end
