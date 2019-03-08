otf2bdf hack.ttf -c C -o hack.bdf -rh 90 -rv 100 -p 21

AV=$( sed -n 's,AVERAGE_WIDTH ,,p' hack.bdf )
AV=$(( ( AV + 32 ) / 10 * 10 ))

sed -i "/AVERAGE_WIDTH/s, .*, $AV," hack.bdf

export SETDIR=/usr/share/bdf2psf

export SETS="\
$SETDIR/ascii.set+\
$SETDIR/linux.set+\
$SETDIR/fontsets/Lat2.256+\
$SETDIR/fontsets/Uni1.512+\
$SETDIR/useful.set\
"

bdf2psf --fb hack.bdf $SETDIR/standard.equivalents $SETS 512 hack.psfu 2>/dev/null

w="$( psf2txt hack.psfu | sed -n '/^Width/s,.* ,,p' )"
h="$( psf2txt hack.psfu | sed -n '/^Height/s,.* ,,p' )"
pxsize=${w}x${h}

gzip -9c < hack.psfu > hack-$pxsize.psfu.gz

echo -n "$size"
echo -n ":$pxsize "
echo "\n"

rm -f hack.psfu hack.bdf

sudo setfont  hack-$pxsize.psfu.gz
sudo showconsolefont
qodem

#sudo setfont
