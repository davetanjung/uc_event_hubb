import 'package:firebase_database/firebase_database.dart';

class FirebaseDBService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Future<String> create({
    required DatabaseReference ref,
    required Map<String, dynamic> data,
  }) async {
    try {
      final newRef = ref.push();
      await newRef.set(data);
      return newRef.key!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> readAll({
    required DatabaseReference ref,
  }) async {
    try {
      final snapshot = await ref.get();
      print('DEBUG: snapshot.exists = ${snapshot.exists}');
      
      if (!snapshot.exists) return [];
      
      final dynamic rawData = snapshot.value;
      print('DEBUG: rawData type = ${rawData.runtimeType}');
      print('DEBUG: rawData = $rawData');
      
      if (rawData == null) return [];
      
      final List<Map<String, dynamic>> result = [];
      
      if (rawData is Map) {
        print('DEBUG: rawData is Map');
        rawData.forEach((key, value) {
          print('DEBUG: key = $key, value type = ${value.runtimeType}');
          print('DEBUG: value = $value');
          
          if (value is Map) {
            try {
              // Try different conversion methods
              final map = <String, dynamic>{};
              
              // Cast to Map and iterate
              final valueAsMap = value as Map;
              for (var entry in valueAsMap.entries) {
                map[entry.key.toString()] = entry.value;
              }
              
              map["id"] = key.toString();
              print('DEBUG: Successfully converted map with id ${map["id"]}');
              result.add(map);
            } catch (e) {
              print('DEBUG: Error converting map: $e');
              rethrow;
            }
          }
        });
      }
      
      print('DEBUG: Total results = ${result.length}');
      return result;
    } catch (e) {
      print('DEBUG: Exception in readAll: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> readById({
    required DatabaseReference ref,
  }) async {
    try {
      final snapshot = await ref.get();
      if (!snapshot.exists) return null;

      return Map<String, dynamic>.from(snapshot.value as Map);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update({
    required DatabaseReference ref,
    required Map<String, dynamic> data,
  }) async {
    try {
      await ref.update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete({
    required DatabaseReference ref,
  }) async {
    try {
      await ref.remove();
    } catch (e) {
      rethrow;
    }
  }
}
