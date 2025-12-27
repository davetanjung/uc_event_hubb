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

  User? _currentUser;
  User? get currentUser => _currentUser;

  // Getters for easy access
  bool get isAuthenticated => _auth.currentUser != null;
  
  String get userName => _currentUser?.fullName ?? 
                        _auth.currentUser?.email?.split('@')[0] ?? 
                        "User";
  
  String get userEmail => _currentUser?.email ?? 
                         _auth.currentUser?.email ?? 
                         "";
  
  String get userId => _auth.currentUser?.uid ?? "";

  // Constructor to listen to auth state changes
  AuthViewModel() {
    _auth.authStateChanges().listen((auth.User? firebaseUser) {
      if (firebaseUser != null) {
        _loadUserData(firebaseUser.uid);
      } else {
        _currentUser = null;
        _token = null;
        notifyListeners();
      }
    });
  }

  // Load user data from database
  Future<void> _loadUserData(String uid) async {
    try {
      _currentUser = await _userRepo.getUserById(uid);
      _token = await _auth.currentUser?.getIdToken();
      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

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
      // 1. Create User in Firebase Auth
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final String uid = cred.user!.uid;

      // 2. Create the User Model object
      User newUser = User(
        id: uid,
        fullName: fullName,
        nim: nim,
        email: email,
        organizationTitle: organizationTitle,
        creditPoints: 0,
        eventsCreatedCount: 0,
      );

      // 3. Save to Realtime Database
      await _userRepo.createUser(newUser);

      // 4. Set current user and token
      _currentUser = newUser;
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
      
      // Load user data from database
      _currentUser = await _userRepo.getUserById(cred.user!.uid);
      _token = await cred.user!.getIdToken();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _setLoading(false);
  }

  Future<void> logout() async {
    await _auth.signOut();
    _token = null;
    _currentUser = null;
    notifyListeners();
  }

  // Refresh user data (useful after updating profile)
  Future<void> refreshUserData() async {
    if (_auth.currentUser != null) {
      await _loadUserData(_auth.currentUser!.uid);
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}