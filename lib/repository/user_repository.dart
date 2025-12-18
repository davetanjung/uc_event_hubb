import 'package:firebase_database/firebase_database.dart';
import 'package:uc_event_hubb/data/service/firebase_db_service.dart';
import 'package:uc_event_hubb/model/user_model.dart';

class UserRepository {
  final FirebaseDBService _db = FirebaseDBService();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

// user
  Future<User?> fetchUser(String userId) async {
    final ref = _database.ref("users/$userId");
    final raw = await _db.readById(ref: ref);

    if (raw == null) return null;
    raw["id"] = userId;
    return User.fromJson(raw, userId);
  }

  Future<void> createUser(User user) async {
    final ref = _database.ref("users/${user.id}");
    await _db.update(ref: ref, data: user.toJson());
  }

  Future<List<User>> fetchAllUsers() async {
    final ref = _database.ref("users"); // Assuming your users are stored under "users" node
    final rawList = await _db.readAll(ref: ref);

    return rawList.map((item) {
      // Assuming the key in the map is the ID, or it's inside the item
      final id = item['id'] ?? item.keys.first; // Adjust based on your actual DB structure
      return User.fromJson(item, id);
    }).toList();
  }

  
Future<User> getUserById(String userId) async {
  final ref = _database.ref("users/$userId");
  final snapshot = await ref.get();
  
  if (!snapshot.exists) {
    throw Exception('User not found');
  }
  
  final data = Map<String, dynamic>.from(snapshot.value as Map);
  return User.fromJson(data, userId);
}
}
