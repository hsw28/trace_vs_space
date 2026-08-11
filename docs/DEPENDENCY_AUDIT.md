# Dependency audit

This file records the scope and result of the dependency audit used to assemble this repository.

## Scope

The retained scope is the manuscript's Figure 2 workflow and the workflow formerly identified as Figure 4, now Figure 3. The former Figure 3 workflow was intentionally excluded because that figure was removed from the manuscript. Supplementary analyses named in the author's rough figure map were retained when they are dependencies of, or direct controls for, Figures 2 and 3; their revised supplementary numbering is not yet confirmed.

`eyeblink/SpikesPerBin_extinction.m` was subsequently added as a current supplementary analysis. MATLAB static analysis reports that it has no additional local-file dependencies and uses MATLAB plus Statistics and Machine Learning Toolbox.

## Method

`matlab.codetools.requiredFilesAndProducts` was run on the retained entry points in the source repository. Its reported local-file closure was copied, preserving `eyeblink/` and `include/`. The copied closure was also searched for absolute filesystem paths, dynamic base-workspace access, file I/O, and MATLAB function/filename mismatches.

Static dependency analysis cannot discover every dependency invoked through strings, `evalin`, `assignin`, or data-dependent branches. The package therefore cannot be certified complete until it is run with the study data.

## Repository-wide verification (2026-08-11)

A second audit was run after assembling the manuscript repository and adding the extinction analysis:

- MATLAB's path was reset with `restoredefaultpath`, the working directory was changed to this repository, and only the repository root, `eyeblink/`, and `include/` were added.
- After adding the demo infrastructure, all 61 MATLAB files were supplied to `matlab.codetools.requiredFilesAndProducts`.
- Result: 61 input files, 61 required local files, and **zero required files outside this repository**.
- All 38 entry points named in the author's retained Figure 2, current Figure 3, and supplementary workflow resolved with `which` to files inside this repository; none were missing or resolved externally.
- Every primary function declaration was checked against its filename; no mismatch remains.
- MATLAB `checkcode` reported no diagnostics containing “undefined,” “unrecognized,” “cannot find,” “not found,” or function-name mismatch language.
- A text audit found no absolute user, home, volume, or cluster paths in the retained MATLAB or documentation files.
- A dynamic-call audit found no `run`, `str2func`, shell, or external-program invocation. The one `feval` call selects a MATLAB colormap by name. `evalin` and `assignin` calls access the five rat/EMG variables and derived fields in the base workspace; they do not load additional code.

This establishes that the statically reachable MATLAB **code** needed by the mapped entry points is present. It does not establish scientific reproducibility: data-dependent branches cannot be exercised without the study data, and required workspace variables/intermediate fields remain unavailable.

The subsequently added `run_demo.m` uses only `plotTrialRastersWithSpeed.m` and its audited local dependencies. Its compact data file contains one Figure 2 session and is not a dependency of the full five-animal analyses.

On 2026-08-11, `run_demo` completed after `restoredefaultpath` under MATLAB R2024b on macOS 26.5.2 (Apple M3 Max, 14 cores, 36 GB RAM). It validated 910 cells, 50 trials, 309 positive events for cell 44, and three axes, and wrote the expected PNG and MAT summary. Runtime including rendering and PNG export was 6.7922 seconds.

### MATLAB path-collision warning

When the audit was first run without resetting MATLAB's path, 12 function names resolved to duplicate files in the larger `ca_imaging` repository. This was a path-precedence artifact, not a missing dependency. Users should not add both repositories to the same MATLAB path. Start a clean MATLAB session in `trace_vs_space` and run `setup`; if necessary, run `restoredefaultpath` first.

## MathWorks products reported by static analysis

- MATLAB
- Image Processing Toolbox
- Statistics and Machine Learning Toolbox
- Parallel Computing Toolbox

The report was generated with MATLAB R2024b (product version 24.2). This records the audit environment; it is not evidence that every analysis was successfully executed in R2024b.

## Corrections made only in this repository

Three copied files had primary function names that did not match their filenames, preventing or jeopardizing invocation by the commands in the figure map. Their declarations were changed to match their filenames:

- `run_task_to_space_interference.m`
- `example_cell_task_sameVsDiffSpace.m`
- `eyeblink/plotTrialRastersWithSpeed.m`

No numerical analysis logic or research results were changed.

## Source provenance

Files were copied from the working tree of `ca_imaging` at Git commit `0ef6f57209e7996acfc74956af0f8dd16da8f601` on 2026-08-11. The source working tree contained uncommitted changes, so the commit alone does not reproduce every copied byte. `TODO: AUTHOR CONFIRMATION` — identify the intended archival source revision and verify whether the copied working-tree versions are the final manuscript versions.

## Known unresolved dependencies

- The analyses require five processed rat structures in the MATLAB base workspace: `rat0222`, `rat0307`, `rat0313`, `rat0314`, and `rat0816`.
- `plotEMGVel` additionally expects `rat0222emg`, `rat0307emg`, `rat0313emg`, `rat0314emg`, and `rat0816emg` in the base workspace.
- The processed data files are not included, and no loader is available.
- Some Figure 3 mutual-information steps require intermediate fields generated by earlier commands. They are not distributed as files.
- `eyeblink/BULKconverttoframe15.m` was added because the author's manual workflow invokes it, even though it is not discoverable from the retained entry points. `run_MI_wCSUS_Shuffle.m` and `mutualinfo_openfield_shuff_wCSUS.m` were retained for the corresponding shuffle path. The driver reads `rat.csus90`, while the supplied preparation notes build `rat.csus15`; the intended mask requires author confirmation.
- The source data were apparently produced using calcium-imaging/CNMF-E processing, but the retained manuscript analysis consumes processed structures. The exact preprocessing software and versions remain to be documented.
- No Python program is in the retained dependency closure.
