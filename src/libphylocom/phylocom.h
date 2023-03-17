                  /*  **************************  */
                  /*  **************************  */
                  /*  *******            *******  */
                  /*  ******   phylocom   ******  */
                  /*  *******            *******  */
                  /*  **************************  */
                  /*  **************************  */

// Analysis of community phylogenetic structure and associated traits

// Cam Webb, Arnold Arboretum of Harvard University
//           cwebb@oeb.harvard.edu
//
// David Ackerly, Dept. of Integrative Biology, UC Berkeley
//           dackerly@berkeley.edu
//
// Steven Kembel, Center for Ecology & Evolutionary Biology, U. Oregon
//			 skembel@uoregon.edu

// This program is free software; you can redistribute it and/or
// modify it under the terms of the BSD 2-Clause License
//
// http://www.opensource.org/licenses/bsd-license.php
//
// Copyright (c) 2003-2011, Campbell Webb, David Ackerly, Steven Kembel
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
// DAMAGE.

// Programming notes:
//
//   <0> indicates counter starts at 0; <1> ... at 1
//   Randomization routines differ between flavors of C and UNIX
//	((int) (((float) X * random()) / (RAND_MAX+1.0))) + 1
//      produces a random integer between 1 and X (inclusive).
//      Substitute your routine that does the same thing

// INCLUDE HEADERS -------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>

#include "winfix.h"

// DEFINITIONS FOR MAIN PROGRAM ------------------------------------------

//#define RAND_MAX (pow(2,31)-1)
#define INFILEP "phylo"
#define INFILEN "phylo.new"
#define INFILET "sample"
#define INFILEM "means"
#define INFILEC "traits"
#define INFILEA "ages"
#define VERSION "4.2"
#define SVNREV  "SVN $Revision: 251 $"

#define MAXNODES 15000 // Higher than the largest no of nodes in phylo
#define MAXTAXA  13000 // Higher than the highest expected code for taxon
#define MAXRUNS 999   // DDA comment: Changed to 999 and significance counters
                      // initialized at one
#define MAXLEVEL 1.0
#define MAXTAXONLENGTH 100 // Number of chars for taxon name
#define MAXPOLYTOMY 1000 // Maximum number of daughters per node
#define MAXBLLENGTH 15 // Number of chars for BL
#define MAXPLOTLENGTH 100 // Number of chars for plot name
#define MAXNOTELENGTH 100
#define MAXTRAITLINE 1000

// DDA:
#define MAXTRAITS 4   // Maximum number of traits in trait files
// #define MAXPOLYTAXA 100 // maximum polytomy size for independent contrasts

// SWK:
#define MAXSWAPS 1000 // Default number of swaps/trials for independent/trial swap
#define TRUE 1
#define FALSE 0

/* GLOBAL VARIABLES ------------------------------------------------------ */
// Capital first letter for global variables (generally)
// small first letters for internal vars

extern FILE *Fp;   // pointer to phylo
extern FILE *Fn;   // pointer to phylo.new
extern FILE *Ft;   // pointer to sample
extern FILE *Fm;   // pointer to means
extern FILE *Fc;   // pointer to traits
extern FILE *Fa;   // pointer to age file

extern char PhyloFile[50]; // default name
extern char SampleFile[50]; // default name
extern char TraitFile[50]; // default name
//int UseFy; // switch for using .fy format input
extern int NoBL; // switch for ignoring branch lenghts
extern int Droptail; // switch for dropping the root tail
extern int FYOUT; // switch for outputting as fy format

extern int RUNS, TRAITS, SWAPS, XVAR, AOTOUT, SWAPMETHOD, RNDPRUNEN, RNDPRUNET, MAKENODENAMES, NULLTESTING;
extern long BURNIN;
extern int Debug;
extern int Verbose;
extern float HILEVEL;
extern int LowSig; // global switch for low vs. high one-tailed sig testing
extern int UseAbund; //use abundance data when available?
extern int FYOUT; // Output to fy format

typedef struct nodes {
	float ***tCh; // tip based character stats
	float ***tChLSig; // one tailed low p vals for tip stats
	float ***tChHSig; // one tailed high p vals for tips stats
	float ***nCh; // node based stats at each node
	float ***nChLSig; // one tailed low p vals for node stats
	float ***nChHSig; // one tailed high p vals for node stats
	float **iCon; // independent contrasts
	float *cSt; // st dev of i.contrast
	int *ordTrt;
	int **rndArr; // vector for random tip sorts
} nodes;

typedef struct phylo {
  char phyname[MAXPLOTLENGTH];
  int nnodes; // equals highest node number plus one, because of 0 node)
  int *up; //up[node]
  int **down;
  int *ldown;
  int *rsister;
  int *noat;
  int *depth; //depth[node]
  float *bl; //bl[node]
  float *tbl;
  float *age; //age[node]
  char **taxon; // name of named node - taxon[node][]
  int ntaxa;  // number of named nodes = total number of names
  int termtaxa; // number of terminal taxa
  char **taxalist; //names of terminal taxa - taxalist[0 to termtaxa-1][]
  int *t2n;  //vector of node #s indexed by 0 to termtaxa-1, as taxalist
  float **dist; // matrix of all node-to-node distances dist[node1][node2]
  int arenotes; // 0 | 1
  char **notes;
  // DA additions
  int maxDepth;
  int *ntip;
  int *nint;
  int **tiplist;
  int **intlist;
  int *upo; // up pass order
} phylo;

//TODO change all algs to just use taxon, checking for terminal status (?)

typedef struct sample { // really need to switch this into a S x T matrix!
  int     nsamples; // # of samples
  int     nrec;     // total # recs in file
  int     maxrec;   // max # of taxa in a sample - use to dim id, abund;
  char  **pname;   // sample names
  int    *srec;     // species per sample srec[sample]
  int	*irec;		// individuals per sample irec[sample]
  int   **id;       // taxon codes (as in taxa) id[sample][rec]
  int   **abund;    // species abundance  abund[sample][rec]
  float **pabund;	// proportional species abundance[sample][rec]
  unsigned long *sppabund;	//species total abundance[id]
  float *psppabund;	//proportional species total abundance[id]
  unsigned long *sppfreq;	//species occurrence frequency[id]
  float *psppfreq;	//proportional species occurrence frequency[id]
  long totabund;	//total abundance across all species
  int     ntaxa;    // number of unique taxa
  char  **taxa;     // vactor of char strings for taxa names
} sample;

typedef struct traits {
  int     ntraits; // # of traits
  char  **trname;
  int     ntaxa;   // # n taxa for which there are traits
  char  **taxon;   // taxon names
  int    *type;    // trait type 0 binary, 3 cont
  float **tr;      // data[taxon#<0>][trait#<0>]
} traits;

typedef struct means {
  float  *mpd;
  float  *sdpd;
  float  *mnnd;
  float  *sdnnd;
} means;

// Sorting params, passed from RemoveDups to Shuffle
extern int TaxaOrder[MAXTAXA+1]; // sp code<1> of the nth ordered taxon<1>
extern int FirstSingleton, LastSingleton; // the rank<1> of the first/last single

// counters used in main, passed to functions
extern int Select;       // subset to use
extern int Sample;       //  The plot (or Sample) counter
extern int PlotsUsed;    //  The number of plots used, that exceed MINIMUM
extern char Method[20]; // type of analysis
extern int TreeView; //TODO fix this and related NodeSig function

// DDA:
// trait Values
extern float **Char;
extern int *CharType; //0 = binary; 1 = multistate; 2 = ordered multistate; 3 = continuous // CW changed 9apr04
// trait conservatism
//int **RndArr;


/* FUNCTION DECLARATION -------------------------------------------------- */

void NodeSig(phylo, sample, int, int);
// void Means();
void VMeans(phylo);
// void Clust();
// void ClustInt();  // internal calculation of means
// void ReadData();
// void SortDistrib();
int  Rel(int A, int B);
// void NRI();
// float NR();
// void NTI();
// float NT();
// void Slide();
// float SlidingN();
// void AppendNote();
// void PrintHeader();
// void Showlevels();
// void Reshuffle();
void Sort(float *, int);
// void Randomize();
// void RandomizeB();
void PrintWelcome(void);
// void FormatHelp();
float Relatedness(phylo, int, int);
void SimpleDist(phylo);
void PhyloVarCovar(phylo);
void ComDist(phylo, sample);
void ComDistNN(phylo, sample);
// void Randomspp();
void Ltt(phylo, sample);
void LttR(phylo, sample);
struct phylo New2fy(char[50]);
void Fy2new(phylo);
struct sample ReadSample(char[50]);
struct phylo ReadPhylogeny(char[6]);
struct means ReadMeans(phylo, char[6]);
void AttachSampleToPhylo(sample, phylo, int *);
void AttachSampleToTraits(sample, traits, int *);
void AttachTraitsToPhylo(traits, phylo, int *);
void AttachPhyloToTraits(phylo, traits, int *);
void DistMatrix(phylo);
void DistMatrixNN(phylo);
float DistToRootNode(phylo, int);
int FindMRCA(phylo, int, int);
void NewickToNexus(phylo);
void WriteNexus(phylo *, int, sample, int, traits, int);
void NAF(phylo *, sample, traits);
void AgeNodes(phylo);
struct traits ReadTraits(char[50]);
void PD(phylo, sample);
void License(void);
void Bladj(phylo);
int CleanPhy(phylo);
int LineOfSight(phylo, int *, int, int);
void SortAction(phylo, int *, int, int);
void Adjust(phylo, int *, int, int);
//void Polytom();
//void ReadDataBladj();
void ComTraitMetric(sample, traits, int, int);
// For reading line endings:
char *myfgets(char *, int, FILE *, int);
int whatnewline(char *);
void IComDist(phylo, sample);
void IComDistNN(phylo, sample);
void VComDist(phylo, sample);
void VComDistNN(phylo, sample);
void FyOut(phylo);

//Comnode
void Comnode(phylo, phylo);

//Ecovolve
struct phylo Prune(phylo, int *);
void RandPrune(phylo, int, int);
void SamplePrune(phylo, sample);

// New recursive Newick-writing functions
void Fy2newRec(phylo);
struct phylo SetNodePointers(phylo);
char *downPar(phylo, int, char *);

// DDA:
void AOT(traits, phylo, int, int);
void NodeCharF(phylo, traits, nodes, int *);
void TipStats(phylo, traits, nodes, int *);
float *TraitsAtNode(int, int, phylo, traits, nodes, int *);
void SigCount(int, int, nodes, nodes);
void PIC(phylo, nodes);
void binPIC(phylo, traits, nodes);
void aot_outfile(phylo, traits, nodes);
// void aot_outscreen();
void RandArray(int, int, int, nodes);

// to be deleted from aot
float *summaryStats(int, float *);
float correlation(int, float *, float *);

// in traits.c - to be deleted from traits.c when aot finished
// void PSig();
void PSigRun(traits, phylo, int, int, int);
void RandArrayT(int **, int, int, int);

// DA additions to io.c
void MakeUpPassOrder(phylo);
void AssignNodeLists(phylo);

// SWK:
void ComStruct(phylo, sample, int, int); //SWK
void IndependentSwap(sample, int); //SWK
void TrialSwap(sample, int);
void OutputSwappedMatrix(phylo, sample, int); //SWK
void PhylogenySampleTaxaShuffle(phylo, sample, int *); //SWK
void PhylogenyAttachShuffle(phylo, sample, int *); //SWK
void TraitsAttachShuffle(sample, traits, int *); //SWK
void RandomizeSampleTaxaShuffle(sample); //SWK
double MeanDistance(phylo, sample, int *, int, int); //SWK
double MeanMinimumDistance(phylo, sample, int *, int, int); //SWK
void traitMetric(float *, unsigned int, float *, int); //SWK
// void CommunityDistance();
// void CommunityDistanceNN();
void CommunityDistanceNull(phylo, sample, int, int, int);
void CommunityDistanceNNNull(phylo, sample, int, int, int);
void PhyloDiversity(phylo, sample);
void RaoDiversity(phylo, sample);
