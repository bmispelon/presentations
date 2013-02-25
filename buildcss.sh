#!/bin/bash

BUILDDIR=pygments_css

# Build all the available css styles

# List all available styles
pygmentize -L styles | awk "NR%2" | grep "^\*" | grep -o "[[:alpha:]]*" > .tmpcss

while read style
do
    pygmentize -S $style -f html > $BUILDDIR/$style.css
done < .tmpcss

rm .tmpcss
