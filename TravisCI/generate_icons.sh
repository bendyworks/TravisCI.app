#!/bin/sh

#  generate_icons.sh
#
#
#  Created by Bradley Grzesiak on 12/22/11.
#  Copyright (c) 2011 Bendyworks. All rights reserved.

set -x
set -e

convert icon.1000.png -geometry 29@29 Icon-Small.png
convert icon.1000.png -geometry 50@50 Icon-Small-50.png
convert icon.1000.png -geometry 57@57 Icon.png
convert icon.1000.png -geometry 58@58 Icon-Small@2x.png
convert icon.1000.png -geometry 72@72 Icon-72.png
convert icon.1000.png -geometry 114@114 Icon@2x.png
convert icon.1000.png -geometry 512@512 "iTunesArtwork (512x512px)"
cp "iTunesArtwork (512x512px)" iTunesArtwork
