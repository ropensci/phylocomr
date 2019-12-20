phylocomr 0.3.2
===============

### MINOR IMPROVEMENTS

* move readme image into man/figures (#30)

### BUG FIXES

* fix for gcc `-fno-common` (#29) (#31)

phylocomr 0.3.0
===============

### NEW FEATURES

* via (#26) (see below) - we now no longer use file paths passed in directly to functions, but instead write to temporary files to run with Phylocom so that we do not alter at all the users files. We note this in the README and package level manual file `?phylocomr`
* package gains new manual file `?phylocomr-inputs` that details the four types of inputs to functions and what format they are expected in, including how they differ for passing in data.frame's vs. file paths (#28)

### BUG FIXES

* for all data.frame traits inputs to fxns, check that the first column is called `name` (Phylocom doesn't accept anything else) (#27)
* fix was originally for `ph_aot()`, but realized this touches almost all functions: Phylocom is case sensitive. We were already making sure all taxon names in phylogenies (tips and nodes) were lowercased, and were lowercasing names in tables passed in, but were not fixing case in file paths passed in by the user. Now across all functions we make sure case is all lowercase for taxon names in any user inputs, so case problems should no longer be an issue. (#26) via @Jez-R

phylocomr 0.2.0
===============

### BUG FIXES

* two fixes for `ph_bladj()`: 1) now we lowercase the taxon name column in the ages data.frame before writing the data.frame to disk to avoid any mismatch due to case (we write the phylogeny to disk with lowercased names); 2) bladj expects the root node name from the phyologeny to be in the ages file; we now check that (#25)


phylocomr 0.1.4
===============

### BUG FIXES

* fix examples (#22)
* improve class checks in internal code, swap `inherits` for `class` (#23)
* small fix to use of fread in C lib; check that fread worked, and if not if it was an EOF error or other error (#24)


phylocomr 0.1.2
===============

### MINOR IMPROVEMENTS

* fixes for failed checks on Solaris

### BUG FIXES

* fix to internals of all functions that handle a phylogeny. `ph_phylomatic` was working fine with very simple trees in all lowercase. we now inernally lowercase all node and tip labels, on any phylogeny inputs (phylo object, newick string, file path (read, then re-write back to disk)). phylomatic wasn't working with any uppercase labels. 


phylocomr 0.1.0
===============

### NEW FEATURES

* released to CRAN
