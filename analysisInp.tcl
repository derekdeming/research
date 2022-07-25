#
# input file for trajectory analysis using VMD
# 
# J. Alfredo Freites
# The TEMPO group @ UCI
# jfreites@uci.edu
#

#Add here the path for the TEMPO analysis libraries
lappend auto_path /DFS-L/DATA/tobias/ddeming/crystallins/tempotools/libs/

# Add your own Libraries here
#source
#load

# Analysis name
set myAnalysis rmsdEvol

# System/Trajectory parameters
#------------------------------------------------------------------------
# dataDir: this is concatenated to the myPSF and file names in theFiles and myReference
# workDir: this is concatenated to the output files
# myPSF: your topology file
# trajFileType: file type for your trajectory file
# step: step length used when reading the trajectory files

set dataDir /DFS-L/DATA/tobias/ddeming/crystallins/gSwt_deamidated/gSWT/
set workDir /DFS-L/DATA/tobias/ddeming/crystallins/gSwt_deamidated/gSWT/analysis/rmsd/
set myPSF gSWT_allh_water_ions.psf
set trajFileType dcd
set step 1

# theFiles: 
# Provide a TCL list of trajectory file names or use your TCL skills to build it

#set theFiles [list filename1 filename2 ...]
set theFiles {}
for {set i 1} {$i < 10} {incr i} {
	lappend theFiles npt0${i}.dcd
}
lappend theFiles npt10.dcd
lappend theFiles npt11.dcd
lappend theFiles npt12.dcd
lappend theFiles npt13.dcd

# theFileRange:
# Provide a TCL list with the first and last frame number to be analyzed in each 
# trajectory file.  
# Leave theFileRange empty (set to "") if you want all the frames of all the files
# to be analyzed.

#set theFileRange [list first1 last1 first2 last2 ...]
set theFileRange ""

#------------------------------------------------------------------------


# Selections list
#------------------------------------------------------------------------
# mySelections: 
# Provide a TCL list of VMD selection sentences or use your TCL skills to build it

#set mySelections [list "selectionSentence1"  "selectionSentence2" ...]
#set mySelections [list {selectionSentence1}  {selectionSentence2} ...]
set mySelections [list {name CA} {name CA and resid 7 to 86 96 to 174} {name CA and resid 7 to 174} {name CA and resid 7 to 86} {name CA and resid 96 to 174}]


#set mySelections [list {name CA} {name CA and resid 7 to 86} {name CA and resid 96 to 174} {name CA and resid 7 to 86 96 to 174} {name CA and resid 7 8 9 10 11 12 13 17 18 19 20 21 22 23 39 40 41 42 43 44 45 46 47 48 49 50 51 52 56 57 58 59 60 61 62 63 64 65 66 67 82 83 84 85 86 96 97 98 99 100 101 105 106 107 108 109 110 111 129 130 131 138 139 140 141 142 146 147 148 149 150 172 173 174} {name CA and resid 7 to 174}]



#------------------------------------------------------------------------


# Output file names list
#------------------------------------------------------------------------
# Output file names are built by compounding three strings: 
# outFilePrefix, outFile, and outFileSuffix
# outFile is any element of theOutFiles list 

# theOutfiles: 
# Provide a TCL list of unique ids ONE for each SELECTION  
# or use your TCL skills to build it
# Leave theOutfiles empty (set to "") to use the selection sentences in mySelections 
# as unique ids

set theOutFiles ""
#set theOutFiles _hbondpath_test

set outFilePrefix rmsd_gSWT_
set outFileSuffix .dat

#------------------------------------------------------------------------


# Additional parameters
#------------------------------------------------------------------------
# Set only what you need for your particular analysis the rest will be ignored

# Evolution parameters
#
# set the correct scale for the time axis in any observable vs. time analysis
#
# used in: any script name somethingEvol
#
# tinit: initial time
# tstep: time step

set tinit 0
set tstep 1

# Reference Parameters
#
# set configuration file name or selection sentences to be used as reference
#
# used in: myreference -- rmsdEvol axisEvol
#	   selref -- ndens hbondPathCyl comEvol contactsEvol
#
# myreference: file name for a single configuration 
#	       dataDir is appended to the file name
# selref: a valid VMD selection sentence 

set myreference gSWT_allh_water_ions.pdb
set selref protein

# Histogram Parameters
#
# used when constructing histograms
#
# used in: ndens
#
# hmin, hmax, rmax: histogram min/max values
# dh, dr: bin width

set hmin -55.0
set hmax 55.0
set dh 0.2

# Cutoff Parameters
#
# set distance and angle cuttof for the VMD commands
# "measure hbonds" and "measure contacts"
#
# used in: hbondsEvol hbondPath hbondPathCyl
#
# distanceCutoff: a distance value in A
# angleCutoff: an angle value in deg

set distanceCutoff 3.5
set angleCutoff 40.0

# Cylindrical Region Parameters
#
# defines a cylindrical ROI by specifying the position of the 
# bases and the square of the radius
# in addition there is also a width for axial positions
#
# used in: hbondPathCyl
#
# bottomCyl: axial position of the bottom base
# topCyl:  axial position of the top base
# widthZ: axial position width
# the cylinder goes from z= bottomCyl-widthZ to z= topCyl+widthZ
# radiusCyl2: the square of the radius

set bottomCyl -11
set topCyl 18
set widthZ 1.4
set radiusCyl2 100

# Hbond network parameters
#
# set some properties of the Hbond network
#
# used in: directedGraph -- hbondPath hbondPathCyl
#	   pathEndsSel -- hbondPath
#
# directedGraph: "yes" if the network has D->A links only 
# pathEndsSel: A valid VMD selection sentence containing atoms in two residues only.

set directedGraph no
set pathEndsSel "(protein and resid 269 and sidechain) or (protein and resid 144 and sidechain)"

# Cartesian Parameters
#
# coordinates and vectors
#
# used in: axisEvol
#
# axisTM: a VMD 3D vector (a Tcl list of three numbers)

set axisTM {0 0 1}

# Weighted histogram Parameters
#
# set the atom type/element list and the label selections
#
# used in: wdens
#
# labelSelections: a list of selection sentences same length as mySelections
# labelFractions: a list of values between 0 and 1 same length as mySelections
# weightType: n or x
# You can leave the label parameters blank or unset if you have no labels

#set labelFractions [list 0.6 0.6]
set labelFractions [list 1.0 1.0]
set labelSelections [list {name H1 H2} {hydrogen and exchangeable}]
set weightType n

#------------------------------------------------------------------------
