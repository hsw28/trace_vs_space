# Trace versus space

MATLAB analysis code for the manuscript **“Hippocampal conditioning code dominates and disrupts the place code.”** The repository contains the analyses supporting the manuscript's quantitative conditioning- and spatial-coding results, together with a compact real-data demonstration.

Repository: [https://github.com/hsw28/trace_vs_space](https://github.com/hsw28/trace_vs_space)

## Repository contents

- Top-level `*.m`: manuscript analysis drivers, mutual-information analyses, spatial analyses, and plotting functions.
- `eyeblink/`: conditioning-period, firing-rate, EMG/velocity, extinction, and example-cell analyses.
- `include/`: local helper functions required by the analysis code.
- `demo_data/rat314sample.mat`: compact real-data demonstration dataset.
- `setup_trace_vs_space.m`: adds the repository code to the MATLAB path and checks required MathWorks products.
- `run_demo.m`: runs and validates the Figure 2 demonstration.

## System requirements

### Software

The code is written in MATLAB. No Python environment, compilation, or external executable is required.

Tested configuration:

- macOS 26.5.2 on Apple silicon
- MATLAB R2024b (24.2)
- Image Processing Toolbox 24.2
- Statistics and Machine Learning Toolbox 24.2
- Parallel Computing Toolbox 24.2

The MATLAB code does not contain operating-system-specific paths. Other operating systems supported by MATLAB R2024b are expected to work but have not been tested for this release.

### Hardware

No non-standard hardware is required. The demonstration was tested on an Apple M3 Max MacBook Pro with 36 GB RAM. Full shuffle and permutation analyses may benefit from additional CPU cores and memory but do not require a GPU or specialized hardware.

## Installation

1. Clone or download the repository:

```bash
git clone https://github.com/hsw28/trace_vs_space.git
```

2. Start MATLAB and change to the repository root.
3. Run:

```matlab
setup_trace_vs_space
```

No separate installation, compilation, or package download is required. Repository setup takes less than one minute on a normal desktop; this estimate excludes installation of MATLAB and its toolboxes.

## Demonstration

The included demonstration uses one real session from rat0314 on 2023-05-22 and reproduces the Figure 2 example-cell visualization for neuron 44.

From a clean MATLAB session:

```matlab
cd('/path/to/trace_vs_space')
setup_trace_vs_space
summary = run_demo;
```

The command validates the input data and generates:

- `outputs/demo/rat0314_2023_05_22_cell44_demo.png`
- `outputs/demo/rat0314_2023_05_22_cell44_demo_summary.mat`

The PNG contains three panels:

1. Trial-aligned calcium-event raster over the animal's speed.
2. Mean trial-aligned speed.
3. Calcium-event PSTH in 0.05-second bins.

The validated dataset contains 910 cells and 50 trials. Neuron 44 contains 309 positive events, and the generated figure contains three analysis axes. On the tested configuration, plotting took 1.3387 seconds in an interactive session. The complete `run_demo` workflow, including rendering and PNG export, took 6.7922 seconds.

## Running the code on your data

The analysis functions that accept `ratNames` can be used with any number of animals and do not require the manuscript's animal identifiers. Load each processed animal structure into the MATLAB base workspace using any valid, unique variable name. For example:

```matlab
loadedDataA = load('animalA.mat', 'animal');
loadedDataB = load('animalB.mat', 'animal');
animalA = loadedDataA.animal;
animalB = loadedDataB.animal;

ratNames = {'animalA','animalB'};
```

Pass that list to functions that accept animal names:

```matlab
run_speedBinMatched(ratNames);
epochModulation_venn(ratNames, ...
    'PlaceOnly', false, 'CollapsePreIntoOne', true);
```

Some manuscript-specific wrapper functions define the original five-animal cohort internally rather than accepting `ratNames`. Those wrappers reproduce the manuscript analysis as written; to apply the underlying analysis to another cohort, use the corresponding function that accepts `ratNames` or update the wrapper's cohort list.

### Animal structure format

For each session date `YYYY_MM_DD`, the analysis functions use the following fields as applicable:

| Field | Expected content |
|---|---|
| `animal.An` | Date label used to identify the final conditioning session. |
| `animal.pos.pos_YYYY_MM_DD` | Numeric matrix with time in column 1 and x/y position in columns 2–3. |
| `animal.Ca_peaks.CA_peaks_YYYY_MM_DD` | Cells-by-events numeric matrix; positive entries are event times and unused entries are `NaN` or nonpositive. |
| `animal.Ca_ts.CA_time_YYYY_MM_DD` | Calcium-imaging timestamps. Functions that receive millisecond timestamps convert them to seconds. |
| `animal.CS_times.CS_YYYY_MM_DD` | Vector of conditioned-stimulus onset times on the same clock as the event and position data. |
| `animal.ratemask.ratemask_YYYY_MM_DD` | Logical or numeric cell-inclusion vector. |
| `animal.Ca_traces.CA_traces_YYYY_MM_DD` | Cells-by-frames calcium traces, where required. |
| `animal.US_times` | Unconditioned-stimulus onset times, where required. |

Some downstream functions consume fields generated by earlier analyses, including `mod`, `epoch`, `spikesperbin`, `ratemask_all`, and mutual-information result structures. Preserve session-date labels across all nested structures.

EMG analyses additionally read one EMG structure per animal from the base workspace. Its variable name is the animal variable name followed by `emg`:

```matlab
loadedEmgA = load('animalA_emg.mat', 'emg');
loadedEmgB = load('animalB_emg.mat', 'emg');
animalAemg = loadedEmgA.emg;
animalBemg = loadedEmgB.emg;
```

The repository operates on processed calcium-event, position, task-timing, and EMG data. Motion correction, source extraction, event inference, and position tracking are outside its scope. Study-data access is described in the manuscript's Data availability statement.

## Manuscript analyses

Start each MATLAB session in the repository root with:

```matlab
setup_trace_vs_space
ratNames = {'rat0222','rat0307','rat0313','rat0314','rat0816'};
```

### Figure 1

Figure 1 is illustrative and does not report a quantitative analysis generated by this repository.

### Figure 2: conditioning-related activity

```matlab
plotTaskVsNonTask(ratNames, 'all');
plotProportionModulated;
epochModulation_venn(ratNames, ...
    'PlaceOnly', false, 'CollapsePreIntoOne', true);
plotEMGVel;
SpikesPerBin(ratNames);
run_speedBinMatched(ratNames);
```

Example raster, speed, and PSTH:

```matlab
plotTrialRastersWithSpeed( ...
    rat0314.Ca_peaks.CA_peaks_2023_05_22, ...
    rat0314.CS_times.CS_2023_05_22, ...
    [-1 2], ...
    rat0314.pos.pos_2023_05_22, ...
    44);
```

### Figure 3: interactions between conditioning and spatial coding

Spatial mutual information with and without conditioning periods is computed using `mutualinfo_openfield_noCSUS` and `mutualinfo_openfield_wCSUS`. Shuffle and matched-event controls use the corresponding `run_MI_*` drivers.

Group summaries and controls:

```matlab
plotMIperAnimal(ratNames);
MIstats;
run_MI_control_matchSpikes(15);
MI_distribution;
run_MI_control_matchSpikesSpeed(15);
MI_distribution2;
```

Example-cell and population interference analyses:

```matlab
example_cell_task_sameVsDiffSpace('rat0314', '2023_05_19', ...
    'CellIdx', [76, 335]);
run_space_to_task_interference(ratNames);

example_cell_quadrants('rat0816', '2022_11_03', ...
    'CellIdx', 39);
run_task_to_space_interference(ratNames);
run_task_space_stability_2x2(ratNames);
run_MI_control_rollingPost;
```

Mutual-information summary functions use previously computed fields including:

- `MI_noCSUS15`, `MI_noCSUS15_all`, and `MI_noCSUS15_shuff`
- `MI_wCSUS`, `MI_wCSUS_all`, and `MI_wCSUS_shuff`
- `MI_noCSUS15_control_all`
- `MI_noCSUS15_controlSpeed_all`
- `ratemask_all`

### Supplementary and control analyses

```matlab
plotTraceFRDist;
epochModulation_venn(ratNames, ...
    'PlaceOnly', false, 'CollapsePreIntoOne', false);
epoch_populationSummary(ratNames, ...
    'MinTrialSpk', 5, 'MinBaseSpk', 5);
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

`SpikesPerBin_extinction` selects the final extinction sessions from dated `CS_extinction_YYYY_MM_DD` fields and stores cells-by-time-bin matrices under `rat.spikesperbin`.

## Analysis-to-figure guide

| Figure | Analysis | Principal code | Output |
|---|---|---|---|
| Figure 1 | Experimental and conceptual illustration | Not applicable | Illustrative figure |
| Figure 2 | Task versus non-task activity | `eyeblink/plotTaskVsNonTask.m` | Rate-comparison figures and statistics |
| Figure 2 | Task-modulated neurons | `eyeblink/plotProportionModulated.m` | Modulation figures and `rat.mod` fields |
| Figure 2 | Epoch-specific modulation | `epochModulation_venn.m` | Bar/Venn figures and result structure |
| Figure 2 | EMG and velocity | `plotEMGVel.m` | EMG/velocity figure |
| Figure 2 | Event rates across task epochs | `eyeblink/SpikesPerBin.m` | Event-rate figures and `rat.spikesperbin` fields |
| Figure 2 | Example-cell raster and PSTH | `eyeblink/plotTrialRastersWithSpeed.m` | Three-panel example-cell figure |
| Figure 2 | Speed-matched event rates | `run_speedBinMatched.m` | Per-animal and population figures and result structure |
| Figure 3 | Spatial mutual information | `mutualinfo_openfield_noCSUS.m`, `mutualinfo_openfield_wCSUS.m`, `plotMIperAnimal.m`, `MIstats.m` | MI structures, figures, and statistics |
| Figure 3 | Event-count and speed controls | `run_MI_control_matchSpikes.m`, `run_MI_control_matchSpikesSpeed.m`, `MI_distribution.m`, `MI_distribution2.m` | Control fields, figures, and statistics |
| Figure 3 | Spatial-to-task interference | `example_cell_task_sameVsDiffSpace.m`, `run_space_to_task_interference.m` | Example-cell and group figures and result structures |
| Figure 3 | Task-to-spatial interference | `example_cell_quadrants.m`, `run_task_to_space_interference.m` | Example-cell and group figures and result structures |
| Figure 3 | Task/non-task spatial stability | `run_task_space_stability_2x2.m` | Stability figures, result structure, and statistics |
| Supplement | Extinction-session event rates | `eyeblink/SpikesPerBin_extinction.m` | Event-rate figures and `rat.spikesperbin` fields |
| Supplement | Additional controls | Commands in “Supplementary and control analyses” | MATLAB figures, structures, and printed statistics |

## Outputs

Most analysis functions create MATLAB figures and return structures or update derived fields within the animal structures. Inferential statistics are printed in the MATLAB Command Window. Functions with explicit save arguments write to the requested location; otherwise, save figures from MATLAB in the format required for the manuscript.

For automated workflows, use a project-relative output directory and construct paths with `fullfile`. The demonstration follows this convention by writing to `outputs/demo/`.

## Troubleshooting

- **Function not found:** change to the repository root and run `setup_trace_vs_space`.
- **Undefined rat or EMG variable:** load the processed structures into the base workspace with the names listed above.
- **Missing derived field:** run the upstream analysis that creates the required `mod`, `epoch`, `spikesperbin`, `ratemask_all`, or MI field.
- **Long runtime:** shuffle, permutation, and resampling analyses are substantially slower than the demonstration and may benefit from parallel workers.
- **Small numerical differences:** stochastic analyses and MATLAB rendering may vary across machines. Use the parameter values and random seeds encoded by the relevant function.

## Code availability and citation

The source code is available at [https://github.com/hsw28/trace_vs_space](https://github.com/hsw28/trace_vs_space).

When using this repository, cite:

> “Hippocampal conditioning code dominates and disrupts the place code.” Nature Communications. Publication details to be added upon publication.

## License

This project is released under the [MIT License](LICENSE).

## Contact

For questions or bug reports, open an issue at [https://github.com/hsw28/trace_vs_space/issues](https://github.com/hsw28/trace_vs_space/issues).
