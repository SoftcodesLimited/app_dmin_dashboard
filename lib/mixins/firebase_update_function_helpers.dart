mixin FirebaseFunctions {
  Map<String, dynamic> generateNestedMap(String nodePath) {
    // Split the path into segments
    List<String> pathSegments =
        nodePath.split('>').map((segment) => segment.trim()).toList();

    // Initialize the root of the nested map
    Map<String, dynamic> nestedMap = {};

    // Start from the root
    Map<String, dynamic> currentMap = nestedMap;

    // Iterate through the segments to build the nested map structure
    for (var i = 0; i < pathSegments.length; i++) {
      String segment = pathSegments[i];

      // Clean up the segment by removing unnecessary parts
      String cleanSegment = segment
          .replaceAll(RegExp(r'\s*\(.*\)\s*'), '')
          .split(':')
          .first
          .trim();

      // If it's the last segment, set the value
      if (i == pathSegments.length - 1) {
        String value = segment.split(':').last.trim();
        currentMap[cleanSegment] = value;
      } else {
        // Otherwise, create a new map or navigate to the existing one
        if (!currentMap.containsKey(cleanSegment)) {
          currentMap[cleanSegment] = {};
        }
        currentMap = currentMap[cleanSegment];
      }
    }

    return nestedMap;
  }

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
