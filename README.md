# Trace versus space

## Project overview

This repository contains MATLAB analysis code for the manuscript **“Hippocampal conditioning code dominates and disrupts the place code.”** It is a manuscript-focused extract from a larger laboratory code repository. The retained scope covers the current Figure 2 workflow and the current Figure 3 workflow (formerly Figure 4). The analysis associated with the former Figure 3 was removed from the manuscript and is not included here.

This repository currently provides code, but not the processed study data or a complete automated reproduction pipeline. Results should not be described as fully reproducible until the unresolved items marked `TODO: AUTHOR CONFIRMATION` have been supplied and the workflow has been tested from a clean environment.

> **Submission status:** the repository now contains the source code and a real-data Figure 2 demonstration. Remaining publication blockers include a clean-machine end-to-end test, final full-analysis instructions/data access, a public repository/archive identifier, a license, and confirmation that the manuscript contains a detailed description or pseudocode of the code's functionality. See `docs/NATURE_CHECKLIST.md` for the exact gate.

## Repository organization

- Top-level `*.m`: manuscript analysis drivers, spatial analyses, mutual-information analyses, and plotting functions.
- `eyeblink/`: conditioning-period, firing-rate, EMG/velocity, and example-cell analyses.
- `include/`: local helper functions required by the retained analyses.
- `setup.m`: adds only these three code locations to the MATLAB path and reports missing MathWorks products.
- `setup_trace_vs_space.m`: project-specific setup entry point used by the demo; `setup.m` is a compatibility wrapper.
- `run_demo.m`: validates and runs the real-data Figure 2 demonstration and saves its outputs.
- `demo_data/rat314sample.mat`: compact one-session demonstration dataset.
- `docs/DEPENDENCY_AUDIT.md`: audit scope, method, provenance, corrections, and unresolved dependencies.
- `docs/NATURE_CHECKLIST.md`: item-by-item status against Nature's official dynamic checklist and the evidence required before submission.

The repository intentionally excludes unrelated or removed workflows from the source laboratory repository, including the former Figure 3 dimensionality/population-geometry analyses, general dimensionality-reduction packages, Neuralynx utilities, RatInABox analyses, raw-data processing utilities, SLURM submission scripts, and exploratory/deprecated files not in the retained dependency closure.

## System requirements

### Operating systems

The retained MATLAB code contains no hard-coded operating-system paths. Source-repository SLURM scripts named MATLAB R2022b on Linux, but those scripts were outside the retained closure and are not evidence of a complete successful manuscript run.

The demonstration has been run on macOS 26.5.2 (Apple silicon). `TODO: AUTHOR CONFIRMATION` — state the operating system(s) on which the final complete analyses were run.

### MATLAB

- MATLAB R2024b is the supported release for this package and was used to run the demonstration.
- MATLAB R2022b is named in historical source-repository SLURM scripts, but is not claimed as a tested release of this package.
- `TODO: AUTHOR CONFIRMATION` — confirm whether MATLAB R2024b was also used for the final full manuscript analyses.

Static analysis reports these required MathWorks products:

- Image Processing Toolbox
- Statistics and Machine Learning Toolbox
- Parallel Computing Toolbox

Parallel Computing Toolbox is reported because retained code contains parallel constructs; `TODO: AUTHOR CONFIRMATION` — confirm whether every documented analysis requires it or only accelerated/parallel branches.

### Python and external software

No Python file or Python package is in the retained dependency closure. No Python environment is required for the processed-data analysis documented here.

The larger source repository contains CIATAH/CNMF-E configuration and other preprocessing utilities, but they are not called by the retained analysis closure. `TODO: AUTHOR CONFIRMATION` — document the software and exact versions used to convert raw imaging data into the processed rat structures, if raw-to-processed reproduction is in scope.

### Hardware

No non-standard hardware is required. A normal desktop capable of holding the processed data in MATLAB memory is sufficient. `TODO: AUTHOR CONFIRMATION` — provide RAM/CPU details from the final clean-machine test and identify whether a cluster was used only to accelerate full shuffle analyses.

## Tested configurations

| Configuration | What was verified |
|---|---|
| macOS 26.5.2; MATLAB R2024b (24.2); Apple M3 Max (14 cores), 36 GB RAM | Static dependency analysis and a successful clean-path execution of the one-session Figure 2 demonstration. |
| Linux; MATLAB R2022b | Release named in source SLURM scripts; `TODO: AUTHOR CONFIRMATION` — confirm successful manuscript runs and Linux distribution. |

## Installation

1. Obtain the repository.
2. Start MATLAB in the repository root.
3. If the larger `ca_imaging` repository has previously been added to the MATLAB path, start a clean MATLAB session or reset the path:

```matlab
restoredefaultpath
```

4. Run the uniquely named setup entry point:

```matlab
setup_trace_vs_space
```

5. Confirm that MATLAB does not report a missing required product.

This analysis package has no separate installation, compilation, or package-download step. Repository path setup takes less than one minute on a normal desktop; this excludes installation of MATLAB and its toolboxes. `TODO: AUTHOR CONFIRMATION` — record a clean-machine setup timing if the editor requests a measured value.

## Data requirements

### Required input files

No study data file is included, and the repository has no verified loader. Before running analyses, load five MATLAB structures into the base workspace with these exact variable names:

```matlab
rat0222
rat0307
rat0313
rat0314
rat0816
```

`plotEMGVel` also expects these variables:

```matlab
rat0222emg
rat0307emg
rat0313emg
rat0314emg
rat0816emg
```

`TODO: AUTHOR CONFIRMATION` — provide the processed `.mat` filename(s), a loader command, checksums, and the public repository/accession or controlled-access procedure for the study data.

### Processed rat structure

The following structure conventions are directly evidenced by the retained code. For each date label `YYYY_MM_DD`:

- `rat.An`: criterion/final analysis date label used to select the last three sessions.
- `rat.pos.pos_YYYY_MM_DD`: numeric position array. Code paths expect time in column 1 and x/y position in columns 2–3.
- `rat.Ca_peaks.CA_peaks_YYYY_MM_DD`: cells-by-events representation used as a numeric matrix or cell-compatible spike/event-time container, depending on the analysis.
- `rat.Ca_ts.CA_time_YYYY_MM_DD`: calcium-imaging timestamps; some code accepts a timestamp column in milliseconds and converts it to seconds.
- `rat.CS_times.CS_YYYY_MM_DD`: conditioning-stimulus onset times.
- `rat.ratemask.ratemask_YYYY_MM_DD`: logical/numeric cell-inclusion mask.
- Some analyses additionally use `rat.Ca_traces`, `rat.US_times`, `rat.mod`, `rat.epoch`, `rat.rates`, `rat.spikesperbin`, `rat.traceneurons`, and precomputed mutual-information fields.

The exact orientation, units, and schema are not consistent enough across every retained function to define a single validated file format without the data. `TODO: AUTHOR CONFIRMATION` — provide a representative structure schema (including units, dimensions, and one example date) and confirm whether event times are seconds or milliseconds in every field.

### Intermediate mutual-information fields

Figure 3 analyses generate or consume fields including:

- `MI_noCSUS15`, `MI_noCSUS15_all`, and `MI_noCSUS15_shuff`
- `MI_wCSUS`, `MI_wCSUS_all`, and `MI_wCSUS_shuff`
- `MI_noCSUS15_control_all`
- `MI_noCSUS15_controlSpeed_all`
- `ratemask_all`

The rough analysis notes construct several `_all` fields manually in a rat- and date-specific order. This is not yet packaged as a verified driver and is a reproducibility risk.

## Minimal demonstration

The repository includes `demo_data/rat314sample.mat`, a compact real-data subset containing calcium-event times, CS onset times, and position samples from rat0314 on 2023-05-22. It runs the Figure 2 example-cell analysis for neuron 44.

From a clean MATLAB session:

```matlab
restoredefaultpath
cd('/path/to/trace_vs_space')
setup_trace_vs_space
summary = run_demo;
```

Expected outputs are written to `outputs/demo/`:

- `rat0314_2023_05_22_cell44_demo.png`: a three-panel figure showing the event raster over speed, mean trial-aligned speed, and the 0.05-second-bin PSTH.
- `rat0314_2023_05_22_cell44_demo_summary.mat`: validation values and measured runtime.

The demo validates that cell 44 exists, the dataset contains exactly 50 CS trials, the figure contains three analysis axes, and both output files are created. On the tested configuration above, the plotting command took **1.3387 seconds** in an interactive session. A clean-path execution of `run_demo`, including rendering and PNG export, took **6.7922 seconds** and reported 910 cells, 50 trials, 309 positive events for cell 44, and three axes. Runtime will vary with hardware and graphics configuration.

## Running the analyses

Start each clean MATLAB session with:

```matlab
setup_trace_vs_space
ratNames = {'rat0222','rat0307','rat0313','rat0314','rat0816'};
```

Then load the processed variables described above. The commands below are transcribed from the author's figure map and were checked against filenames and primary function declarations in this repository. They were not executed because the data are unavailable.

### Figure 2

```matlab
plotTaskVsNonTask(ratNames, 'all');
plotProportionModulated;
epochModulation_venn(ratNames, 'PlaceOnly', false, 'CollapsePreIntoOne', true);
plotEMGVel;
SpikesPerBin(ratNames);
run_speedBinMatched(ratNames);
```

Example-cell/raster commands require the exact cells and dates used in the manuscript:

```matlab
plotTrialRastersWithSpeed(rat0307.Ca_peaks.CA_peaks_2023_06_05, ...
    rat0307.CS_times.CS_2023_06_05, [-1,2], ...
    rat0307.pos.pos_2023_06_05, 17);
```

`TODO: AUTHOR CONFIRMATION` — confirm which Figure 2 panel uses each command, confirm the final example cell(s), and provide exact output filenames.

### Figure 3 (formerly Figure 4)

Base mutual-information values are computed with `mutualinfo_openfield_noCSUS` and `mutualinfo_openfield_wCSUS`; shuffle and matched-event controls use the corresponding `run_MI_*` drivers. The current code still relies on manually assembled intermediate fields, so there is not yet one safe end-to-end command.

`eyeblink/BULKconverttoframe15.m` is included because the author's notes use it to construct `rat.csus15` from `rat.US_times` and `rat.Ca_ts`. The with-task shuffle driver instead reads `rat.csus90`; this inconsistency must be resolved before that control is documented as executable.

Verified entry-point commands from the figure map include:

```matlab
plotMIperAnimal(ratNames);
MIstats;
run_MI_control_matchSpikes(15);
MI_distribution;
run_MI_control_matchSpikesSpeed(15);
MI_distribution2;

example_cell_task_sameVsDiffSpace('rat0314', '2023_05_19', ...
    'CellIdx', [76, 335]);
run_space_to_task_interference(ratNames);
example_cell_quadrants('rat0816', '2022_11_03', 'CellIdx', 39);
run_task_to_space_interference(ratNames);
run_task_space_stability_2x2(ratNames);
run_MI_control_rollingPost;
```

`run_MI_control_rollingPost` accepts an optional window-edge argument; the zero-argument call is present in the author's notes and uses the function's defaults.

`TODO: AUTHOR CONFIRMATION` — consolidate the mutual-information preparation and `_all` field assembly into a verified driver or provide an exact ordered protocol with saved intermediate files.

### Supplementary analyses

The supplementary figure numbers have changed and are intentionally not asserted here. Retained supplementary/control entry points include:

```matlab
plotTraceFRDist;
epochModulation_venn(ratNames, 'PlaceOnly', false, 'CollapsePreIntoOne', false);
epoch_populationSummary(ratNames, 'MinTrialSpk', 5, 'MinBaseSpk', 5);
epochModulation(ratNames);
slidingWindowLatency(ratNames);
SpikesPerBin_extinction(ratNames);
compareVels_allRats(ratNames, [0 2], 1);
plotFRvsSpeedSummary('fdr');
plotFRvsSpeedWithinTrials('correction', 'fdr');
run_accelBinMatched(ratNames);
plotTaskVar_InOut_vs_Distance(ratNames, 'CentroidMethod', 'mode');
plotRateMaskSummary(1);
```

These commands identify the analysis code without claiming current supplementary numbering or a complete derivation of every supplementary panel. `TODO: AUTHOR CONFIRMATION` — provide the final supplement-to-command crosswalk required for archival reproduction.

`SpikesPerBin_extinction` is a current supplementary analysis. By default it analyzes the final two sessions identified from `CS_extinction_YYYY_MM_DD` or the historically misspelled `CS_exinction_YYYY_MM_DD` fields, falling back to dated `CS_` fields if neither extinction prefix is present. It requires matching `CA_peaks_YYYY_MM_DD` data and stores cells-by-time-bin matrices under `rat.spikesperbin`. `TODO: AUTHOR CONFIRMATION` — supply its current supplementary panel number, final options, and expected output filename.

## Manuscript reproduction table

| Current figure | Panel/analysis | Script(s) | Required data | Generated output |
|---|---|---|---|---|
| Figure 1 | `TODO: AUTHOR CONFIRMATION` | Not identified in the supplied map | `TODO` | `TODO` |
| Figure 2 | Task versus non-task activity | `eyeblink/plotTaskVsNonTask.m` | Five rat structures: peaks, CS times, positions/session metadata | MATLAB figure; exact filename is not assigned by the function (`TODO`) |
| Figure 2 | Proportion of task-modulated cells | `eyeblink/plotProportionModulated.m` | Peaks, CS times, position/timestamps; writes `rat.mod` when enabled | MATLAB figures and updated workspace structures; exact saved filename `TODO` |
| Figure 2 | Epoch modulation | `epochModulation_venn.m` | Rat structures and modulation-related session fields | Bar/Venn figures and returned result structure |
| Figure 2 | EMG and velocity | `plotEMGVel.m`, `eyeblink/alignEMGandVelocity.m` | Rat structures plus five `ratXXXXemg` workspace variables | MATLAB figure; exact saved filename `TODO` |
| Figure 2 | Event rate by task epoch | `eyeblink/SpikesPerBin.m` | Peaks, CS times, session timestamps | Figures plus `rat.spikesperbin` workspace fields |
| Figure 2 | Example rasters | `eyeblink/plotTrialRastersWithSpeed.m` | One session's peaks, CS times, position and selected cell IDs | MATLAB figure; exact saved filename `TODO` |
| Figure 2 | Speed-matched task/non-task rates | `run_speedBinMatched.m` | Five rat structures: peaks, position, CS times, ratemask | Returned structure and multiple MATLAB figures; exact filenames `TODO` |
| Figure 3 | Spatial mutual information with/without conditioning | `mutualinfo_openfield_noCSUS.m`, `mutualinfo_openfield_wCSUS.m`, `plotMIperAnimal.m`, `MIstats.m` | Peaks, positions, timestamps, conditioning-frame exclusions, ratemask and shuffle fields | Workspace MI structures, figures, printed statistics |
| Figure 3 | Event-count and speed controls | `run_MI_control_matchSpikes.m`, `run_MI_control_matchSpikesSpeed.m`, `MI_distribution.m`, `MI_distribution2.m` | Precomputed MI fields and five rat structures | Workspace control fields, distribution figures, printed statistics |
| Figure 3 | Spatial-to-task interference | `example_cell_task_sameVsDiffSpace.m`, `run_space_to_task_interference.m` | Peaks, positions, CS times, ratemask | Example and group MATLAB figures; returned structures |
| Figure 3 | Task-to-spatial interference | `example_cell_quadrants.m`, `run_task_to_space_interference.m` | Peaks, positions, CS times, ratemask | Example and group MATLAB figures; returned structures |
| Figure 3 | Task/non-task spatial stability | `run_task_space_stability_2x2.m` | Peaks, positions, CS times, ratemask | Returned structure, figures and printed tests |
| Supplement | Extinction-session event rates | `eyeblink/SpikesPerBin_extinction.m` | Five rat structures with dated extinction CS fields and matching calcium-event fields | MATLAB figures plus `rat.spikesperbin.cpb_YYYY_MM_DD` fields; current panel number and saved filename `TODO` |
| Supplement | Retained controls listed above | See “Supplementary analyses” | Analysis-specific subsets of the processed rat/EMG structures | MATLAB figures, workspace structures and console statistics |

Current panel letters, exact output filenames, and revised supplementary numbering remain `TODO: AUTHOR CONFIRMATION`.

## Output descriptions

Most functions create MATLAB figure windows and return no standardized on-disk artifact. Several analyses also return MATLAB structures or update the five rat variables in the base workspace. Printed inferential statistics go to the MATLAB Command Window. Only isolated functions implement explicit export options.

The manuscript's rough map lists labels such as `perc_mod`, `epochs_bars.svg`, `velemg.svg`, and `task_interferes_with_space`, but the code does not consistently create those names. They are therefore not documented as guaranteed outputs.

`TODO: AUTHOR CONFIRMATION` — define a project-relative `outputs/` convention, exact filenames, file formats, and which outputs correspond to final panels. Do not use user-specific absolute paths; accept an output directory argument and construct paths with `fullfile`.

## Troubleshooting and known limitations

- **Undefined rat variable:** load the five processed rat structures into the MATLAB base workspace using the exact names above.
- **Undefined EMG variable:** load the corresponding `ratXXXXemg` variables before running `plotEMGVel`.
- **Missing field:** many analyses assume earlier computations have added `mod`, `epoch`, `spikesperbin`, `ratemask_all`, or MI fields. Run order is not fully automated.
- **Function not found:** run `setup` from the repository root. Avoid `addpath(genpath(...))` on the larger laboratory repository, which can introduce name collisions.
- **Wrong function copy executes:** the larger `ca_imaging` repository contains duplicate function names. Run `restoredefaultpath`, change to the `trace_vs_space` root, and run `setup`. The repository-wide audit found 12 collisions when the source repository was left on MATLAB's path.
- **Different random result:** several analyses use resampling, permutation, or random splits. Some functions set a seed and others may not. `TODO: AUTHOR CONFIRMATION` — audit and fix seeds for every stochastic manuscript result.
- **Memory/runtime:** some shuffle, permutation, and resampling defaults are computationally intensive. No runtime or memory benchmark is available.
- **Data schema ambiguity:** timestamp units and spike/event container types vary among functions.
- **No raw-data pipeline:** this repository starts from processed rat structures and does not reproduce motion correction, source extraction, event inference, or position tracking.
- **No end-to-end validation:** static analysis cannot resolve every dynamic `evalin`/`assignin` dependency, and the absent data prevent execution testing.
- **Conditioning-mask inconsistency:** `run_MI_wCSUS_Shuffle.m` reads `rat.csus90`, whereas the supplied Figure 3 preparation notes create `rat.csus15`. `TODO: AUTHOR CONFIRMATION` — identify the final intended mask and window.

The retained code has no hard-coded absolute paths. In the larger source repository, absolute paths should be replaced with a user-supplied project/data root, e.g. `dataRoot`, combined with project-relative components using `fullfile(dataRoot, ...)`. Machine-specific paths should never be embedded in analysis functions.

## Code availability and citation

`TODO: AUTHOR CONFIRMATION` — add the public repository URL and archived release DOI after deposit.

When using this code, cite the manuscript:

> `TODO: AUTHOR CONFIRMATION` — complete author list, year, journal, article title, DOI, and preferred software citation.

Source provenance and extraction details are recorded in `docs/DEPENDENCY_AUDIT.md`.

## License

No project-level license was present in the source repository, and none is invented here. Until a license is added, reuse rights are not granted by the repository itself.

`TODO: AUTHOR CONFIRMATION` — choose and add a license compatible with the journal policy and all copied helper-code licenses/provenance.

## Contact

`TODO: AUTHOR CONFIRMATION` — add the maintainer/corresponding-author name, institutional affiliation, and contact email.

## Nature code and software checklist status

The table below is a repository-oriented expansion. The exact wording and submission gate from Nature's official checklist are tracked in `docs/NATURE_CHECKLIST.md`.

| Requirement | Status | Evidence or missing item |
|---|---|---|
| Code directly relevant to the manuscript is available | Satisfied | Manuscript-focused extraction; unrelated and removed workflows excluded. |
| Repository organization and code purpose documented | Satisfied | Overview and organization sections. |
| System requirements documented | Partially satisfied | Products identified statically; final supported OS/MATLAB versions need confirmation. |
| Tested configuration documented | Partially satisfied | Audit environment documented; no clean end-to-end analysis run. |
| Installation instructions supplied | Satisfied | Verified `setup` entry point; no compilation required. |
| Installation time supplied | Missing | Must be measured on a clean machine. |
| Dependencies documented | Partially satisfied | All 61 MATLAB files and 38 mapped manuscript entry points pass clean-path code-dependency checks with zero external code files; data-dependent branches and raw preprocessing remain unresolved. |
| Required input data and formats documented | Partially satisfied | Workspace schema summarized; files, units, loader, checksums and full schema missing. |
| Data availability/access documented | Missing | Public accession or access procedure not supplied. |
| Example data supplied | Satisfied | Compact real data from rat0314, session 2023-05-22, are included under `demo_data/`. |
| Minimal demo, expected output and runtime supplied | Satisfied | `run_demo` completed from a reset MATLAB path in 6.7922 seconds including PNG export; the plotting-only interactive timing was 1.3387 seconds. |
| Complete analysis instructions supplied | Partially satisfied | Verified entry points listed; MI preparation and run order remain manual/incomplete. |
| Main-figure code mapping supplied | Partially satisfied | Figures 2 and 3 mapped; Figure 1 and panel letters need confirmation. |
| Supplementary-figure code mapping supplied | Partially satisfied | Analyses listed without revised numbering, per author instruction; final crosswalk needed for archival reproduction. |
| Output files described | Partially satisfied | Output types documented; standardized paths/names absent. |
| Expected complete-analysis runtime supplied | Missing | Must be measured. |
| Randomness/reproducibility controls documented | Partially satisfied | Known limitation identified; full seed audit pending. |
| Troubleshooting and limitations supplied | Satisfied | Dedicated section included. |
| Code availability and citation supplied | Missing | Repository URL, archive DOI and complete citation pending. |
| License supplied | Missing | Author must select a project license and verify helper-code compatibility. |
| Contact information supplied | Missing | Maintainer/corresponding-author details pending. |
