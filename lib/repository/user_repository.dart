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
}
