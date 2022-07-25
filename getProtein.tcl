#load pdb
mol new gSWT_chainA_VMD.pdb waitfor all

# select each chain protein + water
set chainA [atomselect top "chain A"]
#set chainB [atomselect top "chain B"]

#move chain according to Author's info in the pdb

#$chainB moveby {19.74574 23.45172 -44.41958}

#change HIS names here
set hse [atomselect top "protein and resname HIS"] 
$hse set resname HSE

#set hsd [atomselect top "protein and resname HIS and resid 30"]
#$hsd set resname HSD


#select protein and waters separately in each chain add segment names and write pdbs

foreach chain {A} {
	foreach thing {water protein} seg {WAT HGS} {
		set temp [atomselect top "chain $chain and $thing"]
		$temp set segname ${seg}${chain}
		$temp writepdb ${seg}${chain}.pdb
		$temp delete
	}
}

exit

