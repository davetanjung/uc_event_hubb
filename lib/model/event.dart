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
    final quizzesJson = json["quizzes"] as Map<String, dynamic>? ?? {};

    return Event(
      id: id,
      title: json["title"] ?? "",
      category: json["category"] ?? "",
      creatorId: json["creator_id"] ?? "",
      description: json["description"] ?? "",
      startDate: json["start_date"] ?? "",
      endDate: json["end_date"] ?? "",
      image: json["image"] ?? "",
      kp: json["kp"] ?? "",
      location: json["location"] ?? "",
      mandatory: json["mandatory"] ?? false,
      price: json["price"] ?? 0,
      quota: json["quota"] ?? 0,
      room: json["room"] ?? "",
      committees: List<String>.from(json["committees"] ?? []),
      participantsList: List<String>.from(json["participants_list"] ?? []),
      quizzes: quizzesJson.map(
        (key, value) =>
            MapEntry(key, Quiz.fromJson(key, Map<String, dynamic>.from(value))),
      ),
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
