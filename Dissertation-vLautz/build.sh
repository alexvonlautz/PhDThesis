#!/bin/bash
#
# Build PDF with LaTeX, compress with ghostscript
set -euo pipefail

INPUT=$1
NAME=${INPUT%.*}
JOB=${2:-$NAME}

git clean -fX
pdflatex --jobname=$JOB $NAME
bibtex "$JOB"
pdflatex --jobname=$JOB $NAME
pdflatex --jobname=$JOB $NAME

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
  -dPDFSETTINGS=/ebook \
  -dNOPAUSE -dQUIET -dBATCH \
  -sOutputFile="$JOB"_screen.pdf \
  "$JOB".pdf

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
  -dPDFSETTINGS=/printer \
  -dNOPAUSE -dQUIET -dBATCH \
  -sOutputFile="$JOB"_print.pdf \
  "$JOB".pdf
