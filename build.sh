#!/bin/bash

THEME=medium-white
PYGMENT_STYLE=default
BUILDDIR=builds

rst2s5.py\
    --theme=$THEME\
    --stylesheet=pygments_css/$PYGMENT_STYLE.css\
    --current-slide\
    "${1}" "$BUILDDIR/${1%.*}.html"
