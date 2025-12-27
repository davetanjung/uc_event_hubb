import 'package:flutter/foundation.dart';
import 'package:uc_event_hubb/repository/user_repository.dart';
import 'package:uc_event_hubb/model/user_model.dart';

class UserViewModel with ChangeNotifier {
  final UserRepository _repo = UserRepository();

  List<User> _allUsers = [];
  List<User> _filteredUsers = []; // For search results
  
  List<User> get users => _filteredUsers; // Expose filtered list to View

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allUsers = await _repo.fetchAllUsers();
      _filteredUsers = _allUsers; // Initially, show all
    } catch (e) {
      print("Error fetching users: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchUser(String query) {
    if (query.isEmpty) {
      _filteredUsers = _allUsers;
    } else {
      _filteredUsers = _allUsers.where((user) {
        final lowerQuery = query.toLowerCase();
        return user.fullName.toLowerCase().contains(lowerQuery) ||
               user.nim.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    notifyListeners();
  }
}