import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nari/bases/Webservices.dart';

class ChatdirectAPI {
  int? id;
  String? content;
  String? createdAt;
  String? updatedAt;
  int? chatId;
  int? userId;
  Sender? sender;

  ChatdirectAPI(
      {this.id,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.chatId,
      this.sender});

  ChatdirectAPI.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    chatId = json['chatId'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['chatId'] = this.chatId;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    return data;
  }

  // Fetch messages between two users
  static Future<List<ChatdirectAPI>?> getDirectMessages(
      int senderId, int receiverId) async {
    try {
      final Uri url = Uri.parse(
          "${Webservice.rootURL}/api/messages/direct?senderId=${senderId}&receiverId=${receiverId}");

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        // Convert the list of JSON objects to a list of ChatMessage objects
        print(jsonResponse);
        return jsonResponse
            .map((json) => ChatdirectAPI.fromJson(json))
            .toList();
      } else {
        // Handle non-200 response
        throw Exception(
            'Failed to load chat messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error from API: $e");
      throw e;
    }
  }
}

class Sender {
  String? username;
  String? email;

  Sender({this.username, this.email});

  Sender.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = this.username;
    data['email'] = this.email;
    return data;
  }
}
