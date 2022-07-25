#this is a mock script equivalent to the one of the same name under /anton2fs/raw/tobias/crystallins/
#but adapted to NAMD trajectoies
#the outcome is a summary trajectory with the protein centered and fitted to the first frame
#there is an option to save a portion of the system (e.g. protein only)

#path to the tempotools libraries:
lappend auto_path /DFS-L/DATA/tobias/ddeming/crystallins/tempotools/libs/

package require tempoUserVMD

# a path appended to both dcd and psf files 
set dataDir /DFS-L/DATA/tobias/ddeming/crystallins/gSwt_deamidated/gSWT/

#your simulation psf 
set myPSF gSWT_allh_water_ions.psf

#a list of dcd file names
set myDCDs [list npt01.dcd npt02.dcd npt03.dcd npt04.dcd npt05.dcd npt06.dcd]
set trajType dcd

# a list of frame ranges for each dcd file name above 
# should be a list of 2-element lists with the same number of elements as myDCDs
set theFileRange [list {0 360} {0 327} {0 297} {0 83} {0 363} {0 138}]


#output file prefix (see animate write below)
set outfile gSWT_every1

#output range for the output file (see animate write below)
set myOutRange [list 0 3999]

#frame skip 
set step 1

#selection sentence to center the wrapped configurations
set wrapreftext protein

#selection sentence to use in the fit to the first frame
set fitreftext  "name CA and structure E"

#what do you want to save?
set seltext all 


#--------end of user interface -------------------------------

mol new ${dataDir}$myPSF waitfor all

set sel [atomselect top $seltext]

foreach myFile $myDCDs myRange $theFileRange {
	dopbc -file  ${dataDir}$myFile  -type $trajType -frames [lindex $myRange 0]:${step}:[lindex $myRange 1] -ref $wrapreftext -wrapby segname
}

selfit -sel $fitreftext
animate write $trajType ${outfile}-[lindex $myOutRange 0]-[lindex $myOutRange 1]-every${step}.${trajType} waitfor all sel $sel

exit
