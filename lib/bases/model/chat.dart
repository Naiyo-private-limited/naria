class Chat {
  final int id;
  final String name;
  final bool isGroupChat;

  Chat({required this.id, required this.name, required this.isGroupChat});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'] ?? '',
      isGroupChat: json['isGroupChat'],
    );
  }
}
