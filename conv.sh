#!/bin/bash
if [ $1 = 0 ]; then
  otf2bdf hack.ttf -c C -o hack.bdf -rh 110 -rv 100 -p 40 # 32x64
fi
if [ $1 = 1 ]; then
  otf2bdf hack.ttf -c C -o hack.bdf -rh 090 -rv 100 -p 21 # 16x32
fi
if [ $1 = 2 ]; then
  otf2bdf hack.ttf -c C -o hack.bdf -rh 080 -rv 100 -p 11 # 08x16
fi 


AV=$( sed -n 's,AVERAGE_WIDTH ,,p' hack.bdf )
if [ $1 = 0 ]; then
  AV=$(( ( AV + 30 ) / 10 * 10 )) # 32x64
fi
if [ $1 = 1 ]; then
  AV=$(( ( AV + 40) / 10 * 10 )) # 16x32
fi
if [ $1 = 2 ]; then
  AV=$(( ( AV + 20) / 10 * 10 )) # 08x16
fi
#AV=$(( ( AV + 20) / 10 * 10 ))

sed -i "/AVERAGE_WIDTH/s, .*, $AV," hack.bdf

export SETDIR=/usr/share/bdf2psf

#export SETS="\
#$SETDIR/ascii.set
#"

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

sudo setfont  -v hack-$pxsize.psfx.gz
sudo showconsolefont

read -n 1 x

qodem

#sudo setfont
