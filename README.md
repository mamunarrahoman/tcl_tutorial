# Tcl Tour — Major Applications of Tcl

A single runnable project that walks through the areas Tcl is actually used
for in practice, not just syntax trivia. Each numbered file is a self-contained,
runnable demo; `main.tcl` is a menu that runs any or all of them. This project will 
also serve as a quick reference for things I might forget when automating a live project, 
allowing me to easily refresh my memory when needed.

## Why these modules:
| SL | File | Application area |
|---:|---|---|
| 1 | `01_basics.tcl` | Core language: variables, control flow, procedures |
| 2 | `02_data_structures.tcl` | Lists, arrays, dictionaries |
| 3 | `03_string_regex.tcl` | Text/string processing — Tcl's original niche |
| 4 | `04_file_io.tcl` | File and log processing |
| 5 | `05_error_handling.tcl` | `catch`, `try`, custom errors, robust scripts |
| 6 | `06_oop_tcloo.tcl` | Object orientation with the built-in TclOO package |
| 7 | `07_namespaces.tcl` | Namespaces and reusable packages |
| 8 | `08_networking.tcl` | Sockets — client/server and Tcl's event loop |
| 9 | `09_eda_scripting.tcl` | EDA/VLSI tool scripting and SDC-style constraints |
| 10 | `10_gui_tk.tcl` | GUI with Tk — requires a display |
## Why Tcl still matters:

Tcl is used as an embedded command/extension language and it is the de-facto
scripting layer of the EDA/VLSI industry — Synopsys Design Compiler and
PrimeTime, Cadence Innovus, and the open-source OpenROAD/OpenSTA flow are
all driven mostly by Tcl scripts.

## Running it:

```bash
# Requires: tclsh (Tcl 8.6+). Optionally tcllib for a couple of extras.
tclsh main.tcl          # interactive menu
tclsh main.tcl all      # run every demo end-to-end, non-interactively
tclsh 09_eda_scripting.tcl   # or run any single module directly
```
## A simple Area Calculator using TCL:
```bash
tclsh 10_gui_tk.tcl # To run the Graphical Uswer Interface.
```
![Image description](asset/gui_cal.png)

No external packages are required except `tcllib`'s `sqlite3`-style demos
are skipped gracefully if it isn't installed — every module checks and
degrades cleanly instead of erroring out.
