## Test environments

* local OS X install, R 4.2.2
* macOS Big Sur 10.16, x86_64-apple-darwin17.0, R 4.2.2
* Ubuntu 20.04.5, x86_64-pc-linux-gnu (github actions), R 4.2.2
* Windows Server x64 (build 20348), x86_64-w64-mingw32 (github actions), R 4.2.2
* Fedora Linux, R-devel, clang, gfortran
* Ubuntu Linux 20.04.1 LTS, R-release, GCC
* Windows Server 2022, R-devel, 64 bit
* Debian Linux, R-release, GCC

## R CMD check results

0 errors | 0 warnings | 0 notes


## Reverse dependencies

No errors were found with the two reverse dependencies.

--------

This submission includes a fix for warnings with C functions with mismatched bounds (`[-Warray-parameter=]`) on Linux envs.


Thanks!

Luna Sanchez
