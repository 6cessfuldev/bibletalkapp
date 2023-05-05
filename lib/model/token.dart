class Token {
  final int count;
  final String updateDate;

  Token({required this.count, required this.updateDate});

  //toMap() 함수는 데이터베이스에 저장하기 위해 Map 형태로 변환하는 함수
  Map<String, Object?> toMap() {
    return {
      'count': count,
      'updateDate': updateDate,
    };
  }
}