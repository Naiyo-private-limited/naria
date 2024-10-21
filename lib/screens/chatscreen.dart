import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:nari/bases/api/ChatMessage.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isEmojiVisible = false;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = ChatMessage(
        senderId: "user123",
        message: _controller.text,
        imageUrl: "",
        timestamp: DateTime.now(),
        isMe: true,
      );
      setState(() {
        _messages.add(message);
        _controller.clear();
      });
    }
  }

  void _sendImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final message = ChatMessage(
        senderId: "user123",
        message: "",
        imageUrl: pickedFile.path,
        timestamp: DateTime.now(),
        isMe: true,
      );
      setState(() {
        _messages.add(message);
      });
    }
  }

  String _getMessageDateLabel(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else {
      return DateFormat.yMMMMd().format(date);
    }
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            margin: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: message.isMe ? Color(0xFFEFD611) : Color(0xFF343A40),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft:
                    message.isMe ? Radius.circular(12) : Radius.circular(0),
                bottomRight:
                    message.isMe ? Radius.circular(0) : Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: message.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                message.imageUrl.isEmpty
                    ? Text(
                        message.message,
                        style: TextStyle(
                          fontSize: 16,
                          color: message.isMe ? Colors.black : Colors.white,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(File(message.imageUrl)),
                      ),
                SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: message.isMe ? Colors.black54 : Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.symmetric(
          vertical: 6), // Reduced padding for a cleaner look
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        bool showDateLabel = index == 0 ||
            _messages[_messages.length - 1 - index].timestamp.day !=
                _messages[_messages.length - index].timestamp.day;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showDateLabel)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _getMessageDateLabel(
                      _messages[_messages.length - 1 - index].timestamp),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            _buildMessage(_messages[_messages.length - 1 - index]),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2D33),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2125),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/user_avatar.png'),
              radius: 18,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chat Name",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "Online",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _isEmojiVisible
              ? EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _controller.text += emoji.emoji;
                    });
                  },
                )
              : Container(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFF343A40),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.emoji_emotions, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _isEmojiVisible = !_isEmojiVisible;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          setState(
                              () {}); // Trigger rebuild to manage button appearance
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file, color: Colors.grey),
                      onPressed: _sendImage,
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.grey),
                      onPressed: _sendImage,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
                width:
                    4), // Add a small gap between the input and the send button
            _controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.send, color: Color(0xFFEFD611)),
                    onPressed: _sendMessage,
                  )
                : Container(), // Show the send button only when there is text
          ],
        ),
      ),
    );
  }
}
