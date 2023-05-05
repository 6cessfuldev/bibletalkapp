class Bookmark {
  final int? id;
  final String title;
  final String response;
  String regDate;

  Bookmark({
    this.id,
    required this.title,
    required this.response,
    String? regDate,
  }) : this.regDate = regDate ?? DateTime.now().toString();

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'response': response,
      'regDate': regDate,
    };
  }

}
