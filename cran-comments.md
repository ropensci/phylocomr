## Test environments

* local OS X install, R 3.5.1 patched
* ubuntu 14.04 (on travis-ci), R 3.5.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

  License components with restrictions and base license permitting such:
    MIT + file LICENSE
  File 'LICENSE':
    YEAR: 2018
    COPYRIGHT HOLDER: Scott Chamberlain

## Reverse dependencies

This is a new submission, so there are no reverse dependencies.

--------

This is a new release. I have read and agree to the the CRAN policies at https://cran.r-project.org/web/packages/policies.html

This is a re-submission of the first version. The package now, we hope, appropriately attributes authors of bundled code. We have:

- added AUTHORS and COPYRIGHT files in inst/
- added libphylocom authors to the DESCRIPTION file as cph, with a comment to see AUTHORS and COPYRIGHT files
- changed license of this package to match that of the bundled code (BSD 2)
- mention the libphylocom license in the README, the package level man file (?`phylocomr-package`)
- put a LICENSE-phylocom file in src/libphylocom/ for easier access (the authors of libphylocom didn't have a separate license file)

Thanks!
Scott Chamberlain
