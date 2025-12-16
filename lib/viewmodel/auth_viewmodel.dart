import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:uc_event_hubb/repository/user_repository.dart';
import 'package:uc_event_hubb/model/user_model.dart';

class AuthViewModel with ChangeNotifier {
 final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final UserRepository _userRepo = UserRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _token;
  String? get token => _token;

  // Updated Register function with additional fields
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String nim,
    required String organizationTitle,
  }) async {
    _setLoading(true);

    try {
      // 1. Create User in Firebase Auth (Authentication Table)
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = cred.user!.uid;

      // 2. Create the User Model object
      // We initialize creditPoints and eventsCreatedCount to 0 for new users
      User newUser = User(
        id: uid,
        fullName: fullName,
        nim: nim,
        email: email,
        organizationTitle: organizationTitle,
        creditPoints: 0,
        eventsCreatedCount: 0,
      );

      // 3. Save to Realtime Database using your Repository
      await _userRepo.createUser(newUser);

      // 4. Set Token/State success
      _token = await cred.user!.getIdToken();
      _errorMessage = null;
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _errorMessage = 'The account already exists for that email.';
      } else {
        _errorMessage = e.message;
      }
    } catch (e) {
      _errorMessage = 'An unknown error occurred: $e';
    }

    _setLoading(false);
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _token = await cred.user!.getIdToken();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _setLoading(false);
  }

  void logout() async {
    await _auth.signOut();
    _token = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
