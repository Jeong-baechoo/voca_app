class Definition {
  String meaning;
  String example;
  String translation;

  Definition({
    required this.meaning,
    required this.example,
    required this.translation,
  });

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
        meaning: json["meaning"],
        example: json["example"],
        translation: json["translation"],
      );

  Map<String, dynamic> toJson() => {
        "meaning": meaning,
        "example": example,
        "translation": translation,
      };
}
