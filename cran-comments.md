## Test environments

* local OS X install, R 4.2.2
* macOS Big Sur 10.16, x86_64-apple-darwin17.0 (github actions), R 4.2.2
* Windows Server x64 (build 20348), x86_64-w64-mingw32 (github actions), R 4.2.2
* Ubuntu 20.04.5, x86_64-pc-linux-gnu (github actions), R 4.2.2
* Fedora Linux, R-devel, clang, gfortran
* Windows Server 2022, R-devel, 64 bit
* Debian Linux, R-devel, GCC

## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... [9s] NOTE
Maintainer: 'Luna Luisa Sanchez Reyes <sanchez.reyes.luna@gmail.com>'

New submission

Package was archived on CRAN

Possibly misspelled words in DESCRIPTION:
  executables (7:15)
  
  _As far as we know, the word executables is correct._

CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2023-02-24 as issues were not corrected
    in time.

## Reverse dependencies

No errors were found with the two reverse dependencies.

--------
This is a new submission addressing warnings with C functions with mismatched bounds (`[-Warray-parameter=]`) and variable size (`[-Wstringop-overflow=]` and `[-Wstringop-truncation]`) on Linux envs.


Thanks!

Luna Sanchez
