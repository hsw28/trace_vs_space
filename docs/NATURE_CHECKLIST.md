# Nature Code and Software Submission Checklist gate

Source: [Nature Research Code and Software Submission Checklist](https://www.nature.com/documents/nr-software-policy.pdf), dynamic PDF dated June 2017. Nature Communications identifies this as a dynamic “smart PDF” that must be downloaded and opened in Adobe Reader or similar software.

## Submission decision

**Current result: DEMO MATERIALS PRESENT; FINAL CLEAN-MACHINE VALIDATION AND PUBLICATION METADATA STILL PENDING.**

Do not mark the official checklist complete until every mandatory row below is **PASS** and the commands have been tested from a clean checkout with the deposited example data. `TODO: AUTHOR CONFIRMATION` marks information or material that cannot be derived from the code.

## Exact checklist crosswalk

| Nature requirement | Status | Repository evidence | Required action before submission |
|---|---|---|---|
| Compiled standalone software and/or source code | PASS for source-code availability | 61 MATLAB source files; all 38 mapped manuscript entry points resolve internally; clean-path dependency analysis reports zero external local-code files. | Confirm the copied working-tree versions are the final manuscript versions; create a versioned release/archive. |
| A small simulated or real dataset to demonstrate the software/code | PASS | `demo_data/rat314sample.mat` contains one real Figure 2 session for rat0314. | Confirm redistribution permission and retain only the documented fields. |
| README: all software dependencies and operating systems, including version numbers | PASS for the demo environment | MATLAB R2024b (24.2), required MathWorks products, macOS 26.5.2, and Apple-silicon test hardware are documented. | Confirm the same requirements for the final full analyses. |
| README: versions the software has been tested on | PASS for the demo | The Figure 2 demo and repository-wide static resolution passed under MATLAB R2024b on macOS 26.5.2. | A second independent clean checkout remains recommended. |
| README: any required non-standard hardware | PASS | The author confirms no non-standard hardware is required. | Add CPU/RAM for context after the clean-machine run. |
| Installation guide: instructions | PASS | README instructs users to reset the MATLAB path and run `setup`; `setup.m` verifies MathWorks products. | Re-test from a clean checkout after the final archive is created. |
| Installation guide: typical install time on a normal desktop | PASS as an analysis package | No separate installation is required; path setup takes less than one minute and excludes MATLAB installation. | Optionally record a measured clean-machine setup time. |
| Demo: instructions to run on data | PASS | `run_demo` loads the included data, validates inputs, runs Figure 2 code, and writes project-relative outputs. | Re-run from a clean checkout. |
| Demo: expected output | PASS | README specifies a three-panel PNG and MAT summary; wrapper checks 50 trials, three axes, and output existence. | Record clean-run summary values. |
| Demo: expected runtime on a normal desktop | PASS | Plotting-only runtime was 1.3387 seconds; clean-path `run_demo` runtime including PNG export was 6.7922 seconds on an Apple M3 Max MacBook Pro with 36 GB RAM. | Runtime may vary; repeat during independent testing. |
| Instructions for use: how to run the software on your data | PARTIAL | Required base-workspace variables, major fields, and figure commands are described. | Supply the processed-data loader, exact schema/units, ordered MI preparation steps, and standardized output directory. Resolve `csus15` versus `csus90`. |
| Optional reproduction instructions | PARTIAL | Main Figure 2/current Figure 3 mappings exist; revised supplementary numbering and Figure 1 are incomplete. | Although Nature labels this optional, complete the final main-figure crosswalk and enough supplementary mapping for reviewers to locate the relevant code. |
| Link to code in an open-source repository, when available | **FAIL** | The repository is local, uncommitted, and has no public URL or DOI. | Publish a versioned repository and archive it (for example, with a DOI); add both identifiers to the README and manuscript Code availability statement. |
| Manuscript contains a complete, detailed description of code functionality (i.e. pseudocode) and identifies its location | **UNVERIFIED / manuscript blocker** | The manuscript was not provided and this cannot be satisfied by the repository README alone. | `TODO: AUTHOR CONFIRMATION` — confirm the detailed algorithmic description/pseudocode is in the main text, Methods, or specified elsewhere, and record the section/page in the official form. |

## Additional publication gates

These items are emphasized by Nature's accompanying author guidance even though they are not separate rows in the dynamic form:

- **License: FAIL.** Add an Open Source Initiative-approved license compatible with every redistributed helper function. Do not publish copied third-party code until its provenance and license are verified.
- **Independent test: FAIL.** Nature strongly recommends testing by a colleague unfamiliar with the software. Record the clean-checkout test configuration, tester, date, commands, and result.
- **Code availability statement: FAIL.** Add the final repository URL, archive DOI, access conditions, and software citation to the manuscript.
- **Data availability statement: FAIL/UNVERIFIED.** Add the processed/raw data repository or accession, access conditions, and links/checksums needed for the demo and full analysis.

## Minimum materials still needed from the authors

1. Final full processed study-data location and confirmation that the included demo subset may be redistributed.
2. Exact toolbox versions used for the final complete analyses, if different from the documented R2024b demo environment.
3. Ideally, an independent fresh-checkout repetition of `run_demo`.
4. Final Figure 1 and current panel mapping; final supplementary crosswalk where needed for reviewer navigation.
5. A verified ordered mutual-information preparation protocol and resolution of `csus15` versus `csus90`.
6. Final code provenance/version, public repository URL, archived DOI, software citation, license, and contact details.
7. Manuscript section/page containing the detailed functionality description or pseudocode.
8. Ideally, an independent clean-checkout test by a colleague unfamiliar with the code.

## Final pre-submission test protocol

Once the missing materials are available:

1. Obtain a fresh checkout/archive on a machine that has never used `ca_imaging`.
2. Start MATLAB, run `restoredefaultpath`, change to the repository root, and run `setup`.
3. Load only the deposited demo data using the documented loader.
4. Run the exact demo command and record elapsed time.
5. Verify every expected filename and numeric/structural check.
6. Run each documented main-figure entry point in the stated order and confirm it does not resolve code outside the repository.
7. Record OS, MATLAB/toolbox versions, CPU, RAM, runtime, warnings, and random seeds.
8. Have an independent tester repeat steps 1–5.
9. Change every mandatory row above to PASS only when its evidence is deposited and linked.
