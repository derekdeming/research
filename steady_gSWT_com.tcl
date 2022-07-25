# SCRIPT FOR STEADY STATE PORTION OF TRAJECTORIES #

#path to the tempotools libraries:
lappend auto_path /DFS-L/DATA/tobias/ddeming/crystallins/tempotools/libs/
package require tempoUserVMD
package require pbctools

set dataDir /DFS-L/DATA/tobias/ddeming/crystallins/gSwt_deamidated/gSWT/
set myPSF gSWT_allh_water_ions.pdb
set outfile steady_gSWT_comdist_every1

#excluded npt02 npt03 to ensure steady portion of trajectories
set theFiles {npt03.dcd npt04.dcd npt05.dcd npt06.dcd npt07.dcd npt08.dcd npt09.dcd npt10.dcd}

#set theFileRange [list {0 361} {0 328} {0 298} {0 83} {0 363} {0 370} {0 305} {0 366}]
set trajType dcd


#frame skip
set step 1
set seltext all
set mySels [list {protein and resid 7 to 86} {protein and resid 96 to 174}]




mol new ${dataDir}$myPSF waitfor all
foreach obj $mySels {
	set sel($obj) [atomselect top $obj]
}
foreach obj1 [lrange $mySels 0 end] {
                        foreach obj2 [lrange $mySels 1 end] {
                                set idf(${obj1},${obj2}) [open ${outfile}_[join $obj1 ""]_[join $obj2 ""].dat w]
                        }
}
animate delete all

foreach dcdfile $theFiles { 
        animate delete all
        animate read $trajType ${dataDir}$dcdfile beg 0 end -1 skip 1 waitfor all top
        pbc wrap -centersel "protein" -center com -compound residue -all
	set nframes [molinfo top get numframes]
	for {set i 0} {$i < $nframes} {incr i} {
		animate goto $i
		foreach obj $mySels {
			$sel($obj) frame $i
			$sel($obj) update
			set vec($obj) [measure center $sel($obj) weight mass]
		}
		foreach obj1 [lrange $mySels 0 end] {
			foreach obj2 [lrange $mySels 1 end] {
				puts $idf(${obj1},${obj2}) [vecdist $vec($obj1) $vec($obj2)]
			}
		}
	}
}

foreach obj1 [lrange $mySels 0 end] {
                        foreach obj2 [lrange $mySels 1 end] {
				close $idf(${obj1},${obj2})
			}
}
exit
