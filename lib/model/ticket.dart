class Ticket {
  final String id;               // Firebase key
  final String eventId;          // Which event this ticket belongs to
  final String type;             // e.g., Regular, VIP
  final int price;               // ticket price
  final int stock;               // total available
  final int sold;                // number sold

  Ticket({
    required this.id,
    required this.eventId,
    required this.type,
    required this.price,
    required this.stock,
    required this.sold,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json["id"] ?? "",
      eventId: json["eventId"] ?? "",
      type: json["type"] ?? "",
      price: json["price"] ?? 0,
      stock: json["stock"] ?? 0,
      sold: json["sold"] ?? 0,
    );
  }

  // Convert Ticket → Firebase JSON (excluding id)
  Map<String, dynamic> toJson() {
    return {
      "eventId": eventId,
      "type": type,
      "price": price,
      "stock": stock,
      "sold": sold,
    };
  }
}
