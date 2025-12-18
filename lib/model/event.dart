import 'package:uc_event_hubb/model/quiz.dart';

class Event {
  final String id;
  final String title;
  final String category;
  final String creatorId;
  final String description;
  final String startDate;
  final String endDate;
  final String image;
  final String kp;
  final String location;
  final bool mandatory;
  final int price;
  final Map<String, Quiz> quizzes;
  final int quota;
  final String room;
  final List<String> committees;
  final List<String> participantsList;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.creatorId,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.image,
    required this.kp,
    required this.location,
    required this.mandatory,
    required this.price,
    required this.quizzes,
    required this.quota,
    required this.room,
    required this.committees,
    required this.participantsList,
  });

  factory Event.fromJson(String id, Map<String, dynamic> json) {

    final quizzesRaw = json["quizzes"];
    final Map<String, Quiz> parsedQuizzes = {};
    
    if (quizzesRaw != null && quizzesRaw is Map) {
      quizzesRaw.forEach((key, value) {
        if (value is Map) {

          final quizMap = <String, dynamic>{};
          value.forEach((k, v) {
            quizMap[k.toString()] = v;
          });
          parsedQuizzes[key.toString()] = Quiz.fromJson(key.toString(), quizMap);
        }
      });
    }

    List<String> parsedCommittees = [];
    final committeesRaw = json["committees"];
    if (committeesRaw != null) {
      if (committeesRaw is List) {
        parsedCommittees = committeesRaw.map((e) => e.toString()).toList();
      } else if (committeesRaw is Map) {
        parsedCommittees = committeesRaw.keys.map((e) => e.toString()).toList();
      }
    }

    List<String> parsedParticipants = [];
    final participantsRaw = json["participants_list"];
    if (participantsRaw != null) {
      if (participantsRaw is List) {
        parsedParticipants = participantsRaw.map((e) => e.toString()).toList();
      } else if (participantsRaw is Map) {
        parsedParticipants = participantsRaw.keys.map((e) => e.toString()).toList();
      }
    }

    return Event(
      id: id,
      title: json["title"] ?? "",
      category: json["category"] ?? "",
      creatorId: json["creator_id"] ?? "",
      description: json["description"] ?? "",
      startDate: json["start_date"] ?? "",
      endDate: json["end_date"] ?? "",
      image: json["image"] ?? "",
      kp: json["kp"]?.toString() ?? "",
      location: json["location"] ?? "",
      mandatory: json["mandatory"] ?? false,
      price: json["price"] ?? 0,
      quota: json["quota"] ?? 0,
      room: json["room"] ?? "",
      committees: parsedCommittees,
      participantsList: parsedParticipants,
      quizzes: parsedQuizzes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "category": category,
      "creator_id": creatorId,
      "description": description,
      "start_date": startDate,
      "end_date": endDate,
      "image": image,
      "kp": kp,
      "location": location,
      "mandatory": mandatory,
      "price": price,
      "quota": quota,
      "room": room,
      "committees": committees,
      "participants_list": participantsList,
      "quizzes": quizzes.map(
        (key, quiz) => MapEntry(key, quiz.toJson()),
      ),
    };
  }
}