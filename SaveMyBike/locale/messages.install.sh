#!/bin/bash

POTFILENAME=SaveMyBike.pot

for a in *.po; do
	echo "Installing messages in $a"
	cp $a ../SaveMyBike/SaveMyBike/Assets/Translations/
done


