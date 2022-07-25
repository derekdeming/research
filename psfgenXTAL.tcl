#generate psf/pdb for the dimer
#
# ********************************************************************
# Input Parameters
# ********************************************************************


#segment list
set seglist [list HGSA]

# Base name of all output to be generated
set outname gSWT_allh

# list of topology files 
set topologyList /DFS-L/DATA/tobias/jfreites/toppar/top_all36_prot.rtf

# --------------------------------------------------------------------
# END OF USER INTERFACE

# --------------------------------------------------------------------


# generate the psf file after aliasing atom names
package require psfgen

foreach thing $topologyList {
	topology $thing
}

#Change the HIS to HSE, HSD or HSP
pdbalias residue HIS HSE

#These are all standard
pdbalias atom ILE CD1 CD


foreach seg $seglist {
segment $seg {
	residue 0 GLY
        residue 1 SER
        residue 2 LYS
        residue 3 THR

        pdb ${seg}.pdb
}
coordpdb ${seg}.pdb $seg
}

#patch DISU HGSA:24 HGSB:24

guesscoord
writepsf ${outname}.psf
writepdb ${outname}.pdb
exit
