#!/bin/sh

#  generate_icons.sh
#
#
#  Created by Bradley Grzesiak on 12/22/11.
#  Copyright (c) 2011 Bendyworks. All rights reserved.

set -x
set -e

convert icon.1000.png -geometry 29x29 Icon-Small.png
convert icon.1000.png -geometry 50x50 Icon-Small-50.png
convert icon.1000.png -geometry 57x57 Icon.png
convert icon.1000.png -geometry 58x58 Icon-Small@2x.png
convert icon.1000.png -geometry 72x72 Icon-72.png
convert icon.1000.png -geometry 114x114 Icon@2x.png
convert icon.1000.png -geometry 512x512 "iTunesArtwork (512x512px)"
cp "iTunesArtwork (512x512px)" iTunesArtwork
