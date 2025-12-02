import 'package:firebase_database/firebase_database.dart';
import 'package:uc_event_hubb/data/service/firebase_db_service.dart';
import 'package:uc_event_hubb/model/ticket.dart';

class TicketRepository {
  final FirebaseDBService _db = FirebaseDBService();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // tickets
  Future<List<Ticket>> fetchEventTickets(String eventId) async {
    final ref = _database.ref("eventTickets/$eventId");
    final rawList = await _db.readAll(ref: ref);

    return rawList.map((e) => Ticket.fromJson(e)).toList();
  }

  Future<String> addEventTicket(String eventId, Ticket ticket) async {
    final ref = _database.ref("eventTickets/$eventId");
    return await _db.create(ref: ref, data: ticket.toJson());
  }
}
