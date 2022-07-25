#
# logGenerator
# Description: prints out a log of the analysis
#
# J. Alfredo Freites
# jfreites@uci.edu
#

package provide logGenerator 1.0

namespace eval ::logGenerator {
	namespace export generateLog
	variable Message
	array set Message {
	        tinit "initial time:"
	        tstep "time step:"
		myreference "reference configuration:"
	        selref "origin was set to the COM of:"
		hmin "histogram minium value:"
		hmax "histogram maximum value:"
		dh "histogram bin width:"
        	distanceCutoff "distance cutoff:"
	        angleCutoff "angle cutoff:"
        	bottomCyl "cylinder bottom at:"
        	topCyl "cylinder top at:"
        	radiusCyl2 "square of cylinder raidus:"
        	widthZ "cylinder base width:"
		directedGraph "directed graph?"
		pathEndsSel "ends of the chain:"
		axisTM "tilt angle measure from:"
		coreSel "\"core\" selection:"
	}
}
proc ::logGenerator::generateLog {mySelections theFiles theFileRange theOutFileNames myPSF dataDir workDir nframes myAnalysis args} {
	
	variable Message

        puts "=============================================================="
        puts $myAnalysis
        puts "$nframes configurations analyzed"
        puts "Selections:"
        foreach object $mySelections {
                puts $object
        }
	puts "Topology File:"
	puts $myPSF
        puts "Data Files:"
        foreach dcdfile $theFiles {begFrame endFrame} $theFileRange {
                if {$endFrame == 1000000} {
                        set endFrame end
                }
                puts "$dcdfile from $begFrame to $endFrame"
        }
        puts "Output Files:"
        foreach object $mySelections outfile $theOutFileNames {
                puts "$outfile for $object"
        }
	puts "Data Directory:"
	puts $dataDir
	puts "Output Files Directory:"
	puts $workDir
        puts "Additional Parameters:"
	foreach {key val} $args {
		puts "$Message($key) $val"
	}
        puts "=============================================================="	
}
	
