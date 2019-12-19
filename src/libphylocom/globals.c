/* GLOBAL VARIABLES ------------------------------------------------------ */
// Capital first letter for global variables (generally)
// small first letters for internal vars
#include "phylocom.h"

FILE *Fp;   // pointer to phylo
FILE *Fn;   // pointer to phylo.new
FILE *Ft;   // pointer to sample
FILE *Fm;   // pointer to means
FILE *Fc;   // pointer to traits
FILE *Fa;   // pointer to age file

char PhyloFile[50]; // default name
char SampleFile[50]; // default name
char TraitFile[50]; // default name
//int UseFy; // switch for using .fy format input
int NoBL; // switch for ignoring branch lenghts
int Droptail; // switch for dropping the root tail
int FYOUT; // switch for outputting as fy format

int RUNS, TRAITS, SWAPS, XVAR, AOTOUT, SWAPMETHOD, RNDPRUNEN, RNDPRUNET, MAKENODENAMES, NULLTESTING;
long BURNIN;
int Debug;
int Verbose;
float HILEVEL;
int LowSig; // global switch for low vs. high one-tailed sig testing
int UseAbund; //use abundance data when available?
int FYOUT; // Output to fy format


// Sorting params, passed from RemoveDups to Shuffle
int TaxaOrder[MAXTAXA+1]; // sp code<1> of the nth ordered taxon<1>
int FirstSingleton, LastSingleton; // the rank<1> of the first/last single

// counters used in main, passed to functions
int Select;       // subset to use
int Sample;       //  The plot (or Sample) counter
int PlotsUsed;    //  The number of plots used, that exceed MINIMUM
char Method[20]; // type of analysis
int TreeView; //TODO fix this and related NodeSig function

// DDA:
// trait Values
float **Char;
int *CharType; //0 = binary; 1 = multistate; 2 = ordered multistate; 3 = continuous // CW changed 9apr04
// trait conservatism
//int **RndArr;
