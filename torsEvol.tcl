#
# Analysis name: torsEvol
# Description: calculates interactomic distances as a function of time
# Result: a two column file time | distance for each selection
# Note: selections must contain only two atoms
# 
# J. Alfredo Freites
# jfreites@uci.edu
#

package provide torsEvol 1.1

namespace eval ::torsEvol {
       package require logGenerator
       namespace export prepareFrame writeOutput writeStep doAnalysis initAnalysis logAnalysis
}

#Do specific set up
#------------------------------------------------------------------------

proc ::torsEvol::initAnalysis {} {
        global tinit
        global tstep

        if {![info exists tinit]} {
                set tinit 0
        }
        if {![info exists tstep]} {
                set tstep 1
        }
	return ""
}

#------------------------------------------------------------------------

# Print Analysis log

proc ::torsEvol::logAnalysis {mySelections theFiles theFileRange theOutFileNames myPSF dataDir workDir} {
        global tinit
        global tstep
        global nframes

	logGenerator::generateLog $mySelections $theFiles $theFileRange $theOutFileNames $myPSF $dataDir $workDir $nframes torsEvol tinit $tinit tstep $tstep 
	
	return ""

}

#------------------------------------------------------------------------

# Analysis specific procedures

proc ::torsEvol::prepareFrame {molwork} {
	return ""
}

proc ::torsEvol::writeOutput {object} {
	return ""
}

proc ::torsEvol::writeStep {object result} {
	global tinit
	global tstep
	global nframes
	upvar idf($object) idf

	puts $idf "[expr {$tinit + $tstep*($nframes - 1)}] $result"
	return ""
}

proc ::torsEvol::doAnalysis {sel object} {
	if {[$sel num] != 4} {
		puts "wrong selection in torsEvol"
		exit
	}
        return [measure dihed [$sel get index]]
}
