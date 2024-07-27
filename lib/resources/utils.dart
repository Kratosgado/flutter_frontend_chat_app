import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_frontend_chat_app/resources/assets_manager.dart';

class TypeDecoder {
  static late final Uint8List pic;

  static List<T> fromMapList<T>(dynamic source) {
    return Iterable.castFrom<dynamic, T>(source).toList();
  }

  static Uint8List get defaultPic => pic;

  static Future<void> setDefaultPic() async {
    final ByteData data = await rootBundle.load(ImageAssets.image);
    pic = data.buffer.asUint8List();
  }

  static Uint8List toBytes(String image) => base64Decode(image);
  // static Future<String> saveImageAsAsset(String base64) async {
  //   Uint8List imageData = base64Decode(base64);
  //   final tempDir = await Directory.systemTemp.createTemp();
  //   final filePath = '${tempDir.path}/${imageData.hashCode}.png';
  //   await File(filePath).writeAsBytes(imageData);
  //   return filePath;
  // }

  static String imageToBase64(File image) {
    Uint8List imageData = image.readAsBytesSync();
    return base64Encode(imageData);
  }
}

int fastHash(String id) {
  var hash = 0xcbf29ce484222352;

  var i = 0;
  while (i < id.length) {
    final codeUnit = id.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}
