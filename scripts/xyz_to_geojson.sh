#!/bin/bash
set -o errexit # set -e
set -o nounset # set -u
set -o pipefail

function usage() {
    cat 1>&2 <<COMMENT
Usage
-----
script/xyz_to_geojson.sh

input
-----
plate_data/PAC/plate_combine.dat

output
------
PAC.json : 太平洋プレートの等深線
PAC.mjs : 太平洋プレートの等深線

Need
----
GMT>=6
COMMENT
}

THIS_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

plate_file="${THIS_SCRIPT_DIR}/../plate_data/PAC/plate_combine.dat"

range="130/147/30/47"

# 間隔が異なるので0~100km,150~400kmで分ける

#　0~100kmの等高線を作成。(10km間隔)
awk '$3>=-10 && $3<130 {print $1,$2,$3}' "${plate_file}" |
    gmt blockmedian -R"${range}" -I0.2 |
    gmt triangulate -R"${range}" -I0.1 -Gtmp_0-100.grd
gmt grdcontour tmp_0-100.grd -R"${range}" -C0,10,20,30,40,50,60,70,80,90,100 -Dtmp_0-100.dat

# 150~400kmの等高線を作成。(50km間隔)
awk '$3>=100 && $3<=440 {print $1,$2,$3}' "${plate_file}" |
    gmt blockmedian -R"${range}" -I0.2 |
    gmt triangulate -R"${range}" -I0.1 -Gtmp_150-400.grd
gmt grdcontour tmp_150-400.grd -R"${range}" -C50 -Dtmp_150-400.dat

rm -rf tmp_0-100.grd tmp_150-400.grd

# PAC.jsonの作成
python "${THIS_SCRIPT_DIR}"/GMTAsciiVectors_xyz_to_geojson.py \
    "${THIS_SCRIPT_DIR}"/../PAC.json tmp_0-100.dat tmp_150-400.dat

rm -rf tmp_0-100.dat tmp_150-400.dat gmt.history

# mjs形式に変換
sed '1iexport const PAC =' "${THIS_SCRIPT_DIR}"/../PAC.json > "${THIS_SCRIPT_DIR}"/../PAC.mjs
