import 'package:flutter/material.dart';
import 'package:nari/bases/UserProvider.dart';
import 'package:nari/bases/api/emergencydetailsGet.dart';
import 'package:nari/bases/api/login.dart';
import 'package:nari/screens/chatscreen.dart';

class EmergencyContactsWidget extends StatefulWidget {
  const EmergencyContactsWidget({Key? key}) : super(key: key);

  @override
  _EmergencyContactsWidgetState createState() =>
      _EmergencyContactsWidgetState();
}

class _EmergencyContactsWidgetState extends State<EmergencyContactsWidget> {
  List<EmergencyContacts> emergencyContacts = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadEmergencyContacts();
  }

  Future<void> _loadEmergencyContacts() async {
    try {
      List<EmergencyContacts>? contacts =
          await EmergencyContacts().emergencydetailsGet();
      if (contacts != null && contacts.isNotEmpty) {
        setState(() {
          emergencyContacts = contacts;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print('Error fetching emergency contacts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : hasError
            ? const Center(child: Text('Failed to load emergency contacts.'))
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Display the emergency contacts as avatars
                  Row(
                    children: emergencyContacts
                        .take(3) // Display only the first 3 contacts
                        .map((contact) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () async {
                            print('Tapped on ${contact.id}');
                            User? user = await UserProvider().getUser();
                            // Navigate to ChatScreen when the avatar is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  userid: user?.id ?? 0,
                                  recieverid: contact.id ?? 0,
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[400],
                            backgroundImage: contact.photo != null
                                ? NetworkImage(
                                    contact.photo!) // Use photo if available
                                : null,
                            child: contact.photo == null
                                ? Text(
                                    contact.username != null
                                        ? contact.username!.substring(0, 2)
                                        : 'NA', // Show initials if username is available
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  // Add button
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: () {
                        // Add your onPressed functionality here
                      },
                    ),
                  ),
                ],
              );
  }
}
