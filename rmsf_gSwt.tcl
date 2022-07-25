lappend auto_path /DFS-L/DATA/tobias/ddeming/crystallins/tempotools/libs/
package require tempoUserVMD

set skip 1
set outfile gSWT_rmsf
# set outfile gSwt_rmsf_pt2

# Load in trajectory and calculate
set psf /DFS-L/DATA/tobias/ddeming/crystallins/gSwt_deamidated/gSWT/gSWT_allh_water_ions.psf

#last 100ns dcd file
set dcd /DFS-L/DATA/tobias/ddeming/crystallins/gSwt_deamidated/gSWT/analysis/traj/rmsf_gSWT_protein-0-399999-every2.dcd
set type dcd

set theFileRange [list 0 9999]

set NTsel  "protein and name CA and resid 5 to 90"
set CTsel  "protein and name CA and resid 91 to 178"
set fullsel "protein and name CA and resid 7 to 174"
set NCTDsel "protein and name CA and resid 7 to 86 96 to 174"

set molwork [mol new $psf waitfor all]
animate delete all $molwork
animate read ${type} $dcd beg [lindex $theFileRange 0] end [lindex $theFileRange 1] skip $skip waitfor all $molwork

set sel [atomselect $molwork protein] 
set seglist [lsort -unique [$sel get segname]]
$sel delete

foreach seg $seglist {
	puts "Processing $seg"
	set opf [open ${outfile}_${seg}_[lindex $theFileRange 0]-[lindex $theFileRange 1]-every${skip}.dat w]
  set allsel [atomselect $molwork "protein and name CA and segname $seg"]

	selfit -sel "$NTsel and segname $seg"
	set Nrmsf [measure rmsf $allsel]

	selfit -sel "$CTsel and segname $seg"
	set Crmsf [measure rmsf $allsel]

	selfit -sel "$fullsel and segname $seg"
	set Frmsf [measure rmsf $allsel]
 
 	selfit -sel "$NCTDsel and segname $seg"
	set Armsf [measure rmsf $allsel]
	
  set resids [$allsel get resid]
	foreach n $Nrmsf c $Crmsf f $Frmsf a $Armsf i $resids {
		puts $opf "$i $n $c $f $a"
	}
	close $opf
}

exit
