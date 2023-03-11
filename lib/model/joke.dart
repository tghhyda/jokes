class Joke {
  final String id;
  final String text;
  bool isFun;
  bool isLocked;

  Joke(
      {required this.text,
        required this.id,
      this.isLocked = false,
      this.isFun = false}
      );

  Map<String, dynamic> toJson() =>{
    'id': id,
    'text': text,
    'isLocked': isLocked,
    'isFun': isFun
  };

  static Joke fromJson(Map<String, dynamic> json) =>
      Joke(id: json['id'],
          text: json['text'],
          isLocked: json['isLocked'],
          isFun: json['isFun']);
}
