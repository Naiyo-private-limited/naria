import 'dart:developer';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'package:nari/bases/api/ChatMessage.dart';
import 'package:nari/bases/api/chatdirectGet.dart';

class ChatScreen extends StatefulWidget {
  final int userid;
  final int recieverid;
  const ChatScreen({Key? key, required this.userid, required this.recieverid})
      : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<ChatdirectAPI> _messages = [];
  final ImagePicker _picker = ImagePicker();
  final ChatdirectAPI _chatAPI = ChatdirectAPI();
  bool _isEmojiVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchChatMessages();
  }

  Future<void> _fetchChatMessages() async {
    try {
      final messages = await ChatdirectAPI.getDirectMessages(
          widget.userid, widget.recieverid);
      if (messages != null) {
        setState(() {
          _messages = messages;
        });
      }
    } catch (e) {
      print("Failed to fetch chat messages: $e");
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = ChatdirectAPI(
        content: _controller.text,
        createdAt: DateTime.now().toString(),
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
      final message = ChatdirectAPI(
        createdAt: DateTime.now().toString(),
      );
      setState(() {
        _messages.add(message);
      });
    }
  }

  Future<Location?> getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return location;
  }

  void _sendLiveLocation() async {
    // get current location
    final Location? location = await getLocation();
    if (location != null) {
      location.enableBackgroundMode(enable: true);
      final String sessionId = "LOC${DateTime.now().millisecondsSinceEpoch}";
      location.onLocationChanged.listen((LocationData currentLocation) async {
        // Use current location
        final Uri locationUri =
            Uri.parse('http://34.171.9.179:5000/api/loc/location');
        final Response response = await post(locationUri, body: {
          'sessionId': sessionId,
          'userId': widget.userid.toString(),
          'latitude': currentLocation.latitude.toString(),
          'longitude': currentLocation.longitude.toString(),
        });
        log('Response status: ${response.statusCode}');
        log('Response body: ${response.body}');
      });
    } else {
      // snackbar to show error - Location Permission Denied
      log('Location Permission Denied');
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

  Widget _buildMessage(ChatdirectAPI message) {
    bool isMe = message.userId.toString() == widget.userid.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: isMe
                  ? const Color(
                      0xFFEFD611) // Color for the current user's messages
                  : const Color(
                      0xFF343A40), // Color for the receiver's messages
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft:
                    isMe ? const Radius.circular(12) : const Radius.circular(0),
                bottomRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.content ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    color: isMe ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a')
                      .format(DateTime.parse(message.createdAt ?? "")),
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.black54 : Colors.white54,
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        bool showDateLabel = index == 0 ||
            _messages[_messages.length - 1 - index].createdAt !=
                _messages[_messages.length - index].createdAt;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showDateLabel)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Test',
                  // _getMessageDateLabel(
                  //     _messages[_messages.length - 1 - index].createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
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
      backgroundColor: const Color(0xFF2B2D33),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF1E2125),
        title: const Row(
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
            icon: const Icon(Icons.more_vert, color: Colors.grey),
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFF343A40),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.emoji_emotions, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _isEmojiVisible = !_isEmojiVisible;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          setState(() {});
                        },
                      ),
                    ),
                    // IconButton Location
                    IconButton(
                      icon: const Icon(Icons.location_on, color: Colors.grey),
                      onPressed: _sendLiveLocation,
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: Colors.grey),
                      onPressed: _sendImage,
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.grey),
                      onPressed: _sendImage,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFFEFD611)),
                    onPressed: _sendMessage,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
