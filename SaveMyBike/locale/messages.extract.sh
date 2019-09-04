#!/bin/bash

#################################################################

# set -x

SOURCEROOT=../SaveMyBike/SaveMyBike/
POTFILENAME=SaveMyBike.pot

#################################################################

SOURCES="$(find $SOURCEROOT -name "*.m" -print )"

xgettext -o $POTFILENAME --keyword -k__tr -k__trCtx:1,2c --from-code=UTF-8 $SOURCES

echo "$POTFILENAME created."
