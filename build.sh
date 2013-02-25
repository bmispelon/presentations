#!/bin/bash
BUILDDIR=builds

rst2s5.py\
    --config=${1%.*}.ini\
    "${1}" "$BUILDDIR/${1%.*}.html"
