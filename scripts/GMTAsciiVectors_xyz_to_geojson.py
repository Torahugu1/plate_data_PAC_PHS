"""
plate_dataのプレートデータのgmt ascii vectors形式(xyz)のデータ
ただしzの部分は同じ数値
geojsonに変換して出力する。

Usage
-----
python script/GMTAsciiVectors_to_geojson.py outputgeojson gmtcontourfile1 gmtcontourfile2 ..
カレントディレクトリはどこでもよい。

"""
import sys
import re

import geojson


def convert_to_geojson(fileObject):
    '''
    Parameters
    ----------
    fileObject : file object
        GMT ASCII Vectors file format(input)

    Returns
    -------
    feature_list :

    Note
    ----
    以下のような条件で分割を行う
    >から始まる行（それ以降の文字列はあってもよい）で分割を行う
    分割した結果空文字になった場合(>が連続している場合等)は削除
    '''
    file_str = fileObject.read()
    file_split = re.split(">.*?\n", file_str)  # >****\nの左最短一致でstrを分割
    # 各要素は"lon\tlat\tdepth\nlon\tlat\tdepth\n..."
    file_split_remove = [line for line in file_split if line != '']
    feature_list = []
    for LineString_str in file_split_remove:
        # 改行文字で分割->"lon\tlat\tdepth"
        lineString_list = LineString_str.splitlines()
        LineString_coords = []
        propertiesDict = {
            "name": "PAC",
            "depth_km": "??",
            "line": "dash",
            "color": "orange"
        }
        for lonlatstr in lineString_list:
            # 空白文字で分割
            lon_str, lat_str, depth_str = lonlatstr.split()
            propertiesDict["depth_km"] = depth_str
            lon, lat = float(lon_str), float(lat_str)
            LineString_coords.append((lon, lat))
        LineString = geojson.LineString(LineString_coords)
        feature = geojson.Feature(geometry=LineString, properties=propertiesDict)
        feature_list.append(feature)
    return feature_list


def gmtcontourfiles2geojson(gmtcontourfiles: list[str], outputgeojson: str):
    features = []
    for gmtcontourfile in gmtcontourfiles:
        fileObject = open(gmtcontourfile, mode='r', encoding='utf-8')
        feature = convert_to_geojson(fileObject)
        fileObject.close()
        features.extend(feature)
    feature_collection = geojson.FeatureCollection(features)
    with open(outputgeojson, mode='w') as fileObject:
        geojson.dump(feature_collection, fileObject, indent=2)


if __name__ == '__main__':
    outputgeojson = sys.argv[1]
    gmtcontourfiles = sys.argv[2:]
    gmtcontourfiles2geojson(gmtcontourfiles, outputgeojson)
