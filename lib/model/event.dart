class Event {
  final String id;
  final String title;
  final String location;
  final String room;
  final String floor;
  final String creator;
  final bool mandatory;
  final String category;
  final String date;
  final String kp;
  final String description;
  final int maximumParticipant;
  final String image;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.room,
    required this.floor,
    required this.creator,
    required this.mandatory,
    required this.category,
    required this.date,
    required this.kp,
    required this.description,
    required this.maximumParticipant,
    required this.image,
  });

  factory Event.fromJson(String id, Map<String, dynamic> json) {
    return Event(
      id: id,
      title: json["title"]?.toString() ?? "",
      location: json["location"]?.toString() ?? "",
      room: json["room"]?.toString() ?? "",
      floor: json["floor"]?.toString() ?? "",
      creator: json["creator"]?.toString() ?? "",
      mandatory: json["mandatory"] == true || json["mandatory"] == "true",
      category: json["category"]?.toString() ?? "",
      date: json["date"]?.toString() ?? "",
      kp: json["kp"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      maximumParticipant: json["maximum_participant"] is int 
          ? json["maximum_participant"] 
          : int.tryParse(json["maximum_participant"]?.toString() ?? "0") ?? 0,
      image: json["image"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "location": location,
      "room": room,
      "floor": floor,
      "creator": creator,
      "mandatory": mandatory,
      "category": category,
      "date": date,
      "kp": kp,
      "description": description,
      "maximum_participant": maximumParticipant,
      "image": image,
    };
  }
}