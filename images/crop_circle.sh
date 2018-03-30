#!/bin/bash -eux

convert MH_cropped.png \
        -gravity Center \
        \( -size 225x225 \
           xc:Black \
           -fill White \
           -draw 'circle 100 100 100 0' \
           -alpha Copy \
        \) -compose CopyOpacity -composite \
        -trim output.png

