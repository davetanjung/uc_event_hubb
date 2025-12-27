class Quiz {
  final String id;
  final String correct_answer;
  final Map<String, String> options;
  final String text;

  Quiz({
    required this.id,
    required this.correct_answer,
    required this.options,
    required this.text,
  });

  factory Quiz.fromJson(String id, Map<String, dynamic> json) {
    return Quiz(
      id: id,
      correct_answer: json["correct_answer"]?.toString() ?? "",
      text: json["text"]?.toString() ?? "",
      options: Map<String, String>.from(json["options"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "correct_answer": correct_answer,
      "text": text,
      "options": options,
    };
  }
}
