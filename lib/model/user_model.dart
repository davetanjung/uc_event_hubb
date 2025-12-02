class User {
  final String id; // optional Firebase key
  final String fullName;
  final String nim;
  final String email;
  final String organizationTitle;
  final int creditPoints;
  final int eventsCreatedCount;

  User({
    required this.id,
    required this.fullName,
    required this.nim,
    required this.email,
    required this.organizationTitle,
    required this.creditPoints,
    required this.eventsCreatedCount,
  });

  factory User.fromJson(Map<String, dynamic> json, String id) {
    return User(
      id: id,
      fullName: json['full_name'] ?? '',
      nim: json['nim'] ?? '',
      email: json['email'] ?? '',
      organizationTitle: json['organization_title'] ?? '',
      creditPoints: json['credit_points'] ?? 0,
      eventsCreatedCount: json['events_created_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "nim": nim,
      "email": email,
      "organization_title": organizationTitle,
      "credit_points": creditPoints,
      "events_created_count": eventsCreatedCount,
    };
  }
}
