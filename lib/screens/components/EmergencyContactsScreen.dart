import 'package:flutter/material.dart';
import 'package:nari/bases/api/emergencyGet.dart';

class EmergencyContactsWidget extends StatefulWidget {
  const EmergencyContactsWidget({Key? key}) : super(key: key);

  @override
  _EmergencyContactsWidgetState createState() =>
      _EmergencyContactsWidgetState();
}

class _EmergencyContactsWidgetState extends State<EmergencyContactsWidget> {
  List<String> emergencyContacts = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadEmergencyContacts();
  }

  Future<void> _loadEmergencyContacts() async {
    try {
      List<String>? contacts = await EmergencyContactAPI().emergencyGet();
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
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[400],
                          child: Text(
                            contact.substring(0, 2), // Initials or numbers
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
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
