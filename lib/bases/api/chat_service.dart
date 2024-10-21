import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nari/bases/model/chat.dart';
import 'package:nari/bases/model/message.dart';

class ChatService {
  final String apiUrl =
      'http://34.171.9.179:5000'; // Replace with your backend URL

  // Create a new chat
  Future<Chat?> createChat(
      List<int> userIds, bool isGroupChat, String name) async {
    final response = await http.post(
      Uri.parse('$apiUrl/chats'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userIds': userIds,
        'isGroupChat': isGroupChat,
        'name': name,
      }),
    );

    if (response.statusCode == 201) {
      return Chat.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to create chat');
      return null;
    }
  }

  // Send a message
  Future<Message?> sendMessage(int senderId, List<int> recipientIds,
      String content, bool isGroupChat, String chatName) async {
    final response = await http.post(
      Uri.parse('$apiUrl/messages/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'senderId': senderId,
        'recipientIds': recipientIds,
        'content': content,
        'isGroupChat': isGroupChat,
        'chatName': chatName,
      }),
    );

    if (response.statusCode == 201) {
      return Message.fromJson(jsonDecode(response.body)['message']);
    } else {
      print('Failed to send message');
      return null;
    }
  }

  // Get all messages in a chat
  Future<List<Message>> getChatMessages(int chatId) async {
    final response =
        await http.get(Uri.parse('$apiUrl/chats/$chatId/messages'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Message.fromJson(json)).toList();
    } else {
      print('Failed to retrieve messages');
      return [];
    }
  }
}
