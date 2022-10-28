#!/bin/bash

set nmol 11

for thefile in mol_*.pdb; do
        sed -i 's/END/TER/g' $thefile
	grep -v "CRYST1 " $thefile > $thefile.$$.tmp
	mv $thefile.$$.tmp $thefile
done

cat mol_*.pdb > final_nanotube.pdb

