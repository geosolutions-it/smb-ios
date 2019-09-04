#!/bin/bash

POTFILENAME=SaveMyBike.pot

for a in *.po; do
	echo "Updating messages in $a"
	msgmerge --quiet --update --backup=none --no-fuzzy-matching -s $a $POTFILENAME
done


