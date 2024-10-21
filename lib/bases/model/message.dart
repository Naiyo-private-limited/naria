class Message {
  final int id;
  final String content;
  final int userId;

  Message({required this.id, required this.content, required this.userId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      userId: json['userId'],
    );
  }
}
