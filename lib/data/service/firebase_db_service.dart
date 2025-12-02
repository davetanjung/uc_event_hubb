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

      if (!snapshot.exists) return [];

      final data = snapshot.value as Map<dynamic, dynamic>;

      return data.entries.map((entry) {
        final map = Map<String, dynamic>.from(entry.value);
        map["id"] = entry.key;
        return map;
      }).toList();
    } catch (e) {
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
