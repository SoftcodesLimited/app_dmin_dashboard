
mixin LinkedMapHelperFunction {
  Map<String, dynamic> convertToMap(Map<dynamic, dynamic> original) {
  return original.map((key, value) {
    if (value is Map) {
      // Recursively convert nested LinkedMap
      return MapEntry(key.toString(), convertToMap(value as Map<dynamic, dynamic>));
    } else if (value is List) {
      // Handle lists by converting each element
      return MapEntry(key.toString(), value.map((e) {
        return e is Map ? convertToMap(e as Map<dynamic, dynamic>) : e;
      }).toList());
    } else {
      // Convert the key to String and keep the value as is
      return MapEntry(key.toString(), value);
    }
  });
}

}