class TypeDecoder {
  static List<T> fromMapList<T>(dynamic source) {
    return Iterable.castFrom<dynamic, T>(source).toList();
  }

// static List<T> decodeType<T>({required dynamic source, required T ts}) {
//     return source.map((t) => ts!.fromMap(t)).toList();
//   }
}
