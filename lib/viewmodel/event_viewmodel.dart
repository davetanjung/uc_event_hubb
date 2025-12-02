import 'package:flutter/foundation.dart';
import 'package:uc_event_hubb/repository/event_repository.dart';
import 'package:uc_event_hubb/model/event.dart';

class EventViewModel with ChangeNotifier {
  final EventRepository _repo = EventRepository();

  List<Event> _events = [];
  List<Event> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadEvents() async {
    _setLoading(true);

    try {
      final result = await _repo.fetchEvents();
      _events = result;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _setLoading(false);
  }

  Future<String?> addEvent(Event event) async {
    try {
      final id = await _repo.addEvent(event);
      await loadEvents();
      return id;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateEvent(String id, Event updated) async {
    try {
      await _repo.updateEvent(id, updated);
      await loadEvents();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEvent(String id) async {
    try {
      await _repo.deleteEvent(id);
      await loadEvents();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
