#!/usr/bin/env python
'''
plate_dataのプレートデータのgmt ascii vectors形式のデータを
geojsonに変換して出力する。

Usage
-----
$ python script/GMTAsciiVectors_to_geojson.py
カレントディレクトリはどこでもよい。

Input
-----
palate_data_setting.json #pathプロパティはこのjsonのディレクトリからの相対パスが記されている。
plate_data

Output
------
PHS.json : フィリピン海プレートの等深線
trench.json :トレンチの位置（フィリピン海プレートと陸のプレート、太平洋プレートと陸のプレート）
PHS.mjs : フィリピン海プレートの等深線
trench.mjs :トレンチの位置（フィリピン海プレートと陸のプレート、太平洋プレートと陸のプレート）

'''
from pathlib import Path
import re

import geojson


def convert_to_geojson(fileObject, propertiesDict, reversal=False):
    '''
    Parameters
    ----------
    fileObject : file object
        GMT ASCII Vectors file format(input)
    propertiesDict : dict
        加える属性
    reversal : bool
        Trueならlat, lonの順になる。Falseはlon,latの順。

    Returns
    -------
    feature : dict-like object
        geojsonのfeatureのdict

    Note
    ----
    以下のような条件で分割を行う
    >から始まる行（それ以降の文字列はあってもよい）で分割を行う
    分割した結果空文字になった場合(>が連続している場合等)は削除
    '''
    file_str = fileObject.read()
    file_split = re.split(">.*?\n", file_str)  # >****\nの左最短一致でstrを分割
    # 各要素は"lon\tlat\nlon\tlat\n..."
    file_split_remove = [line for line in file_split if line != '']
    MultiLineString_coords = []
    for LineString_str in file_split_remove:
        # 改行文字で分割->"lon\tlat"
        lineString_list = LineString_str.splitlines()
        LineString_coords = []
        for lonlatstr in lineString_list:
            # 空白文字で分割
            lon_str, lat_str = lonlatstr.split()
            lon, lat = float(lon_str), float(lat_str)
            if reversal:
                lon, lat = lat, lon
            LineString_coords.append((lon, lat))
        LineString_coords = tuple(LineString_coords)
        MultiLineString_coords.append(LineString_coords)
    MultiLineString = geojson.MultiLineString(MultiLineString_coords)
    feature = geojson.Feature(geometry=MultiLineString, properties=propertiesDict)
    return feature


def json2mjs(json_path: str | Path, mjs_path: str | Path, var: str):
    """mjs形式に変換"""
    json_path = Path(json_path)
    mjs_path = Path(mjs_path)
    # 最初の行に付け加える。
    string = json_path.read_text()
    NewString = f'export const {var} = \n' + string
    mjs_path.write_text(NewString)


def output_json(set_list: list, json_path: str | Path):
    feature_list = []
    for pathAndProperties in set_list:
        path: Path = SETTINGDIR / pathAndProperties['path']
        properties = pathAndProperties['properties']
        with path.open(mode='r', encoding='utf-8') as f:
            feature = convert_to_geojson(f, properties, True)
            feature_list.append(feature)
    feature_collection = geojson.FeatureCollection(feature_list)
    json_path = Path(json_path)
    with json_path.open(mode='w') as f:
        geojson.dump(feature_collection, f, indent=2)


# ファイルのパス
myDirPath = Path(__file__).parent

output_trench_json = myDirPath / '../trench.json'
output_PHS_json = myDirPath / '../PHS.json'

plate_data_setting_geojson = myDirPath / '../plate_data_setting.json'
with plate_data_setting_geojson.open(mode='r', encoding='utf-8') as f:
    set_json = geojson.load(f)

# plate_data_setting.jsonが格納されているディレクトリパス
SETTINGDIR = plate_data_setting_geojson.parent

output_json(set_json['trench'], output_trench_json)
output_json(set_json['PHS'], output_PHS_json)

output_trench_mjs = myDirPath / '../trench.mjs'
var = "trench"
json2mjs(output_trench_json, output_trench_mjs, var)

output_PHS_mjs = myDirPath / '../PHS.mjs'
var = "PHS"
json2mjs(output_PHS_json, output_PHS_mjs, var)
