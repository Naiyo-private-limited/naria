import 'package:flutter/material.dart';
import 'package:nari/bases/api/chat_service.dart';
import 'package:nari/bases/model/message.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;

  ChatScreen({required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  void _fetchMessages() async {
    List<Message> messages = await _chatService.getChatMessages(widget.chatId);
    setState(() {
      _messages = messages;
    });
  }

  void _sendMessage() async {
    String content = _messageController.text;
    if (content.isNotEmpty) {
      // Replace with your actual sender ID and recipient ID(s)
      Message? message =
          await _chatService.sendMessage(1, [2], content, false, '');
      if (message != null) {
        setState(() {
          _messages.add(message);
        });
        _messageController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.content),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
