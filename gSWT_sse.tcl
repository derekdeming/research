#path to the tempotools libraries:
lappend auto_path /DFS-L/DATA/tobias/ddeming/crystallins/tempotools/libs/
package require tempoUserVMD

set dataDir /DFS-L/DATA/tobias/ddeming/crystallins/gSwt_deamidated/gSWT/analysis/traj/
set myPSF gSWT_allh_water_ions.pdb

#sse_gS3_every_1 = 7551 frames 
set mySumTraj gSWT_every1-0-3999-every1.dcd
set trajType dcd


set theFileRange [list {0 1420}]


set outfile gSWTxtal_SSE_every1step_every1traj

set step 1


mol new ${dataDir}$myPSF waitfor all

set sel [atomselect top "name CA"]


foreach myRange $theFileRange {
	set idf [open ${outfile}_[lindex $myRange 0]to[lindex $myRange 1]_every${step}.dat w]
	animate delete all
	animate read $trajType ${dataDir}$mySumTraj beg [lindex $myRange 0] end [lindex $myRange 1] skip $step waitfor all
	set nframes [molinfo top get numframes]
	for {set i 0} {$i < $nframes} {incr i} {
		animate goto $i
		$sel frame $i
		mol ssrecalc top
		puts $idf [$sel get structure]
	}
	close $idf
}

exit

