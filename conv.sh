#otf2bdf hack.ttf -c C -o hack.bdf -rh 120 -rv 100 -p 40 # 32x64
otf2bdf hack.ttf -c C -o hack.bdf -rh 103 -rv 103 -p 20 # 16x32
#otf2bdf hack.ttf -c C -o hack.bdf -rh 80 -rv 100 -p 11 # 08x16

AV=$( sed -n 's,AVERAGE_WIDTH ,,p' hack.bdf )
AV=$(( ( AV + 20 ) / 10 * 10 )) # 32x64
#AV=$(( ( AV + 20) / 10 * 10 )) # 08x16
#AV=$(( ( AV + 20) / 10 * 10 ))

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
#bdf2psf --fb hack.bdf $SETDIR/standard.equivalents $SETS 256 hack.psfu 2>/dev/null

w="$( psf2txt hack.psfu | sed -n '/^Width/s,.* ,,p' )"
h="$( psf2txt hack.psfu | sed -n '/^Height/s,.* ,,p' )"
pxsize=${w}x${h}

gzip -9c < hack.psfu > hack-$pxsize.psfx.gz

echo -n "$size"
echo -n ":$pxsize "
echo "\n"

rm -f hack.psfu hack.bdf

sudo setfont  -v hack-$pxsize.psfu.gz
sudo showconsolefont

#read

#qodem

#sudo setfont
