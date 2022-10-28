mol new monomer.pdb

set nmol 11
set angle [expr 360/$nmol]
set angle2 20
set nlayer 6

## Center the molecule 
set all [atomselect top all]
set gec [measure center $all]
$all moveby [vecscale 1.0 $gec]

# radius = (radius 0 0)
$all moveby {25 0 0}

### Layer#1 with nmol molecules
for {set j 1} {$j <= $nmol} {incr j} {
        $all move [transaxis z $angle]
        $all writepdb layer_1-mol_$j.pdb
}

mol delete 0

###  Making nlayer
for {set j 1} {$j <= $nmol} {incr j} {
        mol new layer_1-mol_$j.pdb
        set all2 [atomselect top all]
        for {set k 2} {$k <= $nlayer} {incr k} {
                ### Rotation of the next layers $angle
                $all2 move [transaxis z $angle2]
            	### Distance between 2 layers
	    	$all2 moveby {0 0 14}
                $all2 writepdb layer_$k-mol_$j.pdb
        }
}

#mol delete all

for {set k 1} {$k <= $nlayer} {incr k} {
        for {set j 1} {$j <= $nmol} {incr j} {
                mol new layer_$k-mol_$j.pdb
	}
}

### Changing resid for $nmolx$nlayer
for {set i 1} {$i <= [expr $nlayer*$nmol]} {incr i} {
	mol top $i
	set sel [atomselect top all]
	$sel set resid [expr $i-1]
	$sel writepdb [format "mol_%03d.pdb" [expr $i-1]]
}

puts "Run nanotube_step2.sh with correct nmol. Add END at the end of the final PDB."
quit
