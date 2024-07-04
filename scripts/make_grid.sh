#!/bin/bash
set -o errexit # set -e
set -o nounset # set -u
set -o pipefail

function usage() {
    cat 1>&2 <<COMMENT
フィリピン海プレートと太平洋プレートのgrdデータを出力する

Input
-----
./plate_data/*

Output
------
./PHS.surface.grd
./PAC.surface.grd
./pic/PHS.surface.grd.png
./pic/PAC.surface.grd.png

Need
----
GMT>=6
COMMENT
}


THIS_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ディレクトリ作成
mkdir -p "${THIS_SCRIPT_DIR}/../pic"

#移動
cd "${THIS_SCRIPT_DIR}/../plate_data" || exit
#以下はplate_dataからの相対パス

# PHS用---------------------------------------

# PHS_SW (Baba et al., 2002, PEPI)
b10=./baba/plate_d10km_baba.dat

# PHS_SW (Nakajima and Hasegawa, 2007, JGR)
n50=./nakajima/plate_d50km_nakajima2.dat
n60=./nakajima/plate_d60km_nakajima2.dat
n80=./nakajima/plate_d80km_nakajima2.dat
n100=./nakajima/plate_d100km_nakajima2.dat
n120=./nakajima/plate_d120km_nakajima2.dat
n140=./nakajima/plate_d140km_nakajima2.dat
n160=./nakajima/plate_d160km_nakajima2.dat
n180=./nakajima/plate_d180km_nakajima2.dat

# PHS_SW (Hirose et al., 2008, JGR)
f10=./sw/plate_d10km.dat
f20=./sw/plate_d20km.dat
f30=./sw/plate_d30km.dat
#f30_2=./sw/plate_d30km_2.dat
f40=./sw/plate_d40km.dat
f40_2=./sw/plate_d40km_2.dat
f50=./sw/plate_d50km.dat
f50_2=./sw/plate_d50km_2.dat
f60=./sw/plate_d60km.dat

# PHS_Kanto (Hirose et al., 2008, Zishin)
fk10=./kanto/plate_d10km.dat
fk20=./kanto/plate_d20km.dat
fk30=./kanto/plate_d30km.dat
fk40=./kanto/plate_d40km.dat
fk50=./kanto/plate_d50km.dat
fk60=./kanto/plate_d60km.dat
fk70=./kanto/plate_d70km.dat
fk80=./kanto/plate_d80km.dat
fk90=./kanto/plate_d90km.dat
fk70_2=./kanto/plate_d70km_2.dat
fk80_2=./kanto/plate_d80km_2.dat
fk90_2=./kanto/plate_d90km_2.dat

# PHS_Izu (Nakajima et al., 2009, JGR)
fi10=./izu3/plate_d10km.dat
fi20=./izu3/plate_d20km.dat
fi30=./izu3/plate_d30km.dat
fi40=./izu3/plate_d40km.dat
fi50=./izu3/plate_d50km.dat
fi60=./izu3/plate_d60km.dat
fi70=./izu3/plate_d70km.dat
fi80=./izu3/plate_d80km.dat
fi90=./izu3/plate_d90km.dat
fi100=./izu3/plate_d100km.dat
fi110=./izu3/plate_d110km.dat
fi120=./izu3/plate_d120km.dat
fi130=./izu3/plate_d130km.dat
fi140=./izu3/plate_d140km.dat

grdFile="$THIS_SCRIPT_DIR/../PHS.surface.grd"

range=130/141/30.5/37
#bashのプロセス置換
cat \
    <(cat $b10 | grep -v "^>" | awk '{print $1,$2,10}') \
    <(cat $n50 | grep -v "^>" | awk '{print $1,$2,50}') \
    <(cat $n60 | grep -v "^>" | awk '{print $1,$2,60}') \
    <(cat $n80 | grep -v "^>" | awk '{print $1,$2,80}') \
    <(cat $n100 | grep -v "^>" | awk '{print $1,$2,100}') \
    <(cat $n120 | grep -v "^>" | awk '{print $1,$2,120}') \
    <(cat $n140 | grep -v "^>" | awk '{print $1,$2,140}') \
    <(cat $n160 | grep -v "^>" | awk '{print $1,$2,160}') \
    <(cat $n180 | grep -v "^>" | awk '{print $1,$2,180}') \
    <(cat $f10 | grep -v "^>" | awk '{print $1,$2,10}') \
    <(cat $f20 | grep -v "^>" | awk '{print $1,$2,20}') \
    <(cat $f30 | grep -v "^>" | awk '{print $1,$2,30}') \
    <(cat $f40 | grep -v "^>" | awk '{print $1,$2,40}') \
    <(cat $f40_2 | grep -v "^>" | awk '{print $1,$2,40}') \
    <(cat $f50 | grep -v "^>" | awk '{print $1,$2,50}') \
    <(cat $f50_2 | grep -v "^>" | awk '{print $1,$2,50}') \
    <(cat $f60 | grep -v "^>" | awk '{print $1,$2,60}') \
    <(cat $fk10 | grep -v "^>" | awk '{print $1,$2,10}') \
    <(cat $fk20 | grep -v "^>" | awk '{print $1,$2,20}') \
    <(cat $fk30 | grep -v "^>" | awk '{print $1,$2,30}') \
    <(cat $fk40 | grep -v "^>" | awk '{print $1,$2,40}') \
    <(cat $fk50 | grep -v "^>" | awk '{print $1,$2,50}') \
    <(cat $fk60 | grep -v "^>" | awk '{print $1,$2,60}') \
    <(cat $fk70 | grep -v "^>" | awk '{print $1,$2,70}') \
    <(cat $fk80 | grep -v "^>" | awk '{print $1,$2,80}') \
    <(cat $fk90 | grep -v "^>" | awk '{print $1,$2,90}') \
    <(cat $fk70_2 | grep -v "^>" | awk '{print $1,$2,70}') \
    <(cat $fk80_2 | grep -v "^>" | awk '{print $1,$2,80}') \
    <(cat $fk90_2 | grep -v "^>" | awk '{print $1,$2,90}') \
    <(cat $fi10 | grep -v "^>" | awk '{print $1,$2,10}') \
    <(cat $fi20 | grep -v "^>" | awk '{print $1,$2,20}') \
    <(cat $fi30 | grep -v "^>" | awk '{print $1,$2,30}') \
    <(cat $fi40 | grep -v "^>" | awk '{print $1,$2,40}') \
    <(cat $fi50 | grep -v "^>" | awk '{print $1,$2,50}') \
    <(cat $fi60 | grep -v "^>" | awk '{print $1,$2,60}') \
    <(cat $fi70 | grep -v "^>" | awk '{print $1,$2,70}') \
    <(cat $fi80 | grep -v "^>" | awk '{print $1,$2,80}') \
    <(cat $fi90 | grep -v "^>" | awk '{print $1,$2,90}') \
    <(cat $fi100 | grep -v "^>" | awk '{print $1,$2,100}') \
    <(cat $fi110 | grep -v "^>" | awk '{print $1,$2,110}') \
    <(cat $fi120 | grep -v "^>" | awk '{print $1,$2,120}') \
    <(cat $fi130 | grep -v "^>" | awk '{print $1,$2,130}') \
    <(cat $fi140 | grep -v "^>" | awk '{print $1,$2,140}') |
    gmt blockmean -I0.01/0.01 -R"${range}" |
    gmt surface -I0.01/0.01 -R"${range}" -G"${grdFile}" -T0.25 -M100k

#図の描画　${gridFilePng}.png
gridFilePng="$THIS_SCRIPT_DIR/../pic/PHS.surface.grd"
gmt begin "${gridFilePng}" png
gmt pscoast -Jm1 -Ggray -Ba5g5 -R"$range"
gmt grdimage "${grdFile}"
gmt grdcontour "${grdFile}" -C10 -A10
gmt end

# PAC用-------------------------------------------------------------------------
# PAC_Hokkaido (Kita et al., 2010, EPSL)
# PAC_Tohoku (Nakajima and Hasegawa, 2006, GRL)
# PAC_Kanto (Nakajima et al., 2009, JGR)
PACdata=./PAC/plate_combine.dat

range=130/147/30/47
grdFile="${THIS_SCRIPT_DIR}/../PAC.surface.grd"

gmt blockmean -I0.2/0.2 -R"${range}" <"$PACdata" |
    gmt surface -I0.2/0.2 -R"${range}" -G"${grdFile}" -T0.25 -M100k

#図の描画　${gridFilePng}.png
gridFilePng="${THIS_SCRIPT_DIR}/../pic/PAC.surface.grd"
gmt begin "${gridFilePng}" png
gmt pscoast -Jm1 -Ggray -Ba5g5 -R"${range}"
gmt grdimage "${grdFile}"
gmt grdcontour "${grdFile}" -C10 -A10
gmt end
