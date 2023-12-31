import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

typedef Id = String;

class TypeDecoder {
  static List<T> fromMapList<T>(dynamic source) {
    return Iterable.castFrom<dynamic, T>(source).toList();
  }

  static Future<String> saveImageAsAsset(String base64) async {
    Uint8List imageData = base64Decode(base64);
    final tempDir = await Directory.systemTemp.createTemp();
    final filePath = '${tempDir.path}/${imageData.hashCode}.png';
    await File(filePath).writeAsBytes(imageData);
    return filePath;
  }

  static Future<String> imageToBase64(File image) async {
    Uint8List imageData = image.readAsBytesSync();
    return base64Encode(imageData);
  }
}
