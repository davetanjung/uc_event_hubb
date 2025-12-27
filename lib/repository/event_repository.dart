import 'package:firebase_database/firebase_database.dart';
import 'package:uc_event_hubb/data/service/firebase_db_service.dart';
import 'package:uc_event_hubb/model/event.dart';

class EventRepository {
  final FirebaseDBService _db = FirebaseDBService();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // events  
  Future<List<Event>> fetchEvents() async {
    final ref = _database.ref("events");
    final rawList = await _db.readAll(ref: ref);

    return rawList.map((item) {
      final id = item['id'] as String;
      return Event.fromJson(id, item);
    }).toList();
  }

  Future<List<Event>> fetchMandatoryEvents() async {
    final ref = _database.ref("events");
    final rawList = await _db.readAll(ref: ref);

    return rawList
        .map((item) {
          final id = item['id'] as String;
          return Event.fromJson(id, item);
        })
        .where((event) => event.mandatory == true)
        .toList();
  }

  Future<String> addEvent(Event event) async {
    final ref = _database.ref("events");
    return await _db.create(ref: ref, data: event.toJson());
  }

  Future<void> updateEvent(String id, Event event) async {
    final ref = _database.ref("events/$id");
    await _db.update(ref: ref, data: event.toJson());
  }

  Future<void> deleteEvent(String id) async {
    final ref = _database.ref("events/$id");
    await _db.delete(ref: ref);
  }
}