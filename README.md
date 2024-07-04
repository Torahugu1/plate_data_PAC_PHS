# plate_data_PAC_PHS

はじめに、これは弘瀬冬樹氏が公開している太平洋とフィリピン海プレートのプレート境界面のデータをもとに加工したデータ群と加工用に作成したスクリプトが格納されているものである。  
[プレート形状の数値データ](https://www.mri-jma.go.jp/Dep/sei/fhirose/plate/PlateData.html)

## データ構成

pic: 画像データ  
plate_data: 元データ  
scripts: スクリプトデータ  
PAC.{json,mjs}: 太平洋プレートの等深線  
PHS.{json,mjs}: フィリピン海プレートの等深線  
trench.{json,mjs}: trench  
PAC.surface.grd: 太平洋プレートの GMTgrd データ  
PHS.surface.grd: フィリピン海プレートの GMTgrd データ

## スクリプト実行に必要な環境

- GMT>=6
- python>=3.9
  - geojson

## データ作成コマンド

```bash
scripts/make_grid.sh
python scripts/GMTAsciiVectors_to_geojson.py
scripts/xyz_to_geojson.sh
```

## その他

PAC.json,PHS.json,trench.json は[地理院地図](https://maps.gsi.go.jp/)でドロップすると表示される。

## 引用文献

- Baba, T., Y. Tanioka, P. R. Cummins, and K. Uhira (2002), The slip distribution of the 1946 Nankai earthquake estimated from tsunami inversion using a new plate model, Phys. Earth Planet. Inter., 132, 59-73.
- 弘瀬冬樹・中島淳一・長谷川　昭 (2007), Double-Difference Tomography 法による西南日本の３次元地震波速度構造およびフィリピン海プレートの形状の推定, 地震 2, 60, 1-20.
- Hirose, F., J. Nakajima, and A. Hasegawa (2008), Three-dimensional seismic velocity structure and configuration of the Philippine Sea slab in southwestern Japan estimated by double-difference tomography, J. Geophys. Res., 113, B09315, doi:10.1029/2007JB005274.
- 弘瀬冬樹・中島淳一・長谷川　昭 (2008), Double-Difference Tomography 法による関東地方の３次元地震波速度構造およびフィリピン海プレートの形状の推定, 地震 2, 60, 123-138.
- Kita, S., T. Okada, A. Hasegawa, J. Nakajima, and T. Matsuzawa (2010), Anomalous deepening of a seismic belt in the upper-plane of the double seismic zone in the Pacific slab beneath the Hokkaido corner: Possible evidence for thermal shielding caused by subducted forearc crust materials, Earth Planet. Science Lett., 290, 415-426.
- Nakajima, J., and A. Hasegawa (2006), Anomalous low-velocity zone and linear alignment of seismicity along it in the subducted Pacific slab beneath Kanto, Japan: Reactivation of subducted fracture zone?, Geophys. Res. Lett., 33, L16309, doi: 10.1029/2006GL026773.
- Nakajima, J., and A. Hasegawa (2007), Subduction of the Philippine Sea plate beneath southwestern Japan: Slab geometry and its relationship to arc magmatism, J. Geophys. Res., 112, B08306, doi:10.1029/2006JB004770.
- Nakajima, J., F. Hirose, and A. Hasegawa (2009), Seismotectonics beneath the Tokyo metropolitan area, Japan: Effect of slab-slab contact and overlap on seismicity, J. Geophys. Res., 114, B08309, doi:10.1029/2008JB006101.
