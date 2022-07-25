#Set up single CRY protein in a water box starting from a single protein charmm compatible psf/pdb

#Input: the file name of the psf/pdb pair and the length of the cube edge
#Output: three files
# $infile_water_ions.psf
# $infile_water_ions.pdb
# $infile_water_ions.cons.pdb
#
# where $infile is the input name

#will add psf/pdb to this name
set infile 	gSWT_allh

#cube edge length
set a 100


#----------- END OF USER INTERFACE -------------------
lappend auto_path /DFS-L/DATA/tobias/ddeming/crystallins/tempotools/libs/

package require tempoUserVMD
package require solvate
package require autoionize

set mymin [expr -0.5 * $a]
set mymax [expr 0.5 * $a]

#load the intial structure

mol new $infile.psf
mol addfile $infile.pdb waitfor all

#center it

centering -mol top 

#write the centered structure to disk

animate write pdb ${infile}_centered.pdb waitfor all

#solvate the centered structure in a cubic  box of given edge length

solvate $infile.psf ${infile}_centered.pdb -o ${infile}_solvated -s WT -minmax [list [list $mymin $mymin $mymin] [list $mymax $mymax $mymax]]

#neutralize the solvated structure

autoionize -psf ${infile}_solvated.psf -pdb ${infile}_solvated.pdb -neutralize -o ${infile}_water_ions -seg IONS  

#load the final configuration to generate the constraints file

mol new ${infile}_water_ions.psf
mol addfile ${infile}_water_ions.pdb waitfor all

[atomselect top all] set beta 0.0
[atomselect top backbone] set beta 20.0
[atomselect top all] writepdb ${infile}_water_ions.cons.pdb

exit
