class ChatMessage {
  final String senderId;
  final String message;
  final String imageUrl;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.senderId,
    required this.message,
    required this.imageUrl,
    required this.timestamp,
    required this.isMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId'],
      message: json['message'],
      imageUrl: json['imageUrl'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      isMe: json['isMe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'message': message,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'isMe': isMe,
    };
  }
}
