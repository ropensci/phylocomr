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
