import 'package:flutter/material.dart';
import 'package:nari/bases/UserProvider.dart';
import 'package:nari/bases/api/emergencydetailsGet.dart';
import 'package:nari/bases/api/login.dart';
import 'package:nari/screens/chatscreen.dart';
import '../../bases/api/emergencycontactPost.dart';

class EmergencyContactsWidget extends StatefulWidget {
  const EmergencyContactsWidget({Key? key}) : super(key: key);

  @override
  _EmergencyContactsWidgetState createState() =>
      _EmergencyContactsWidgetState();
}

class _EmergencyContactsWidgetState extends State<EmergencyContactsWidget> {
  List<EmergencyContacts>? contacts;
  bool isLoading = true;
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    try {
      final contactsList = await EmergencyContacts().emergencydetailsGet();
      setState(() {
        contacts = contactsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        contacts = [];
        isLoading = false;
      });
    }
  }

  Future<void> _showAddContactDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Emergency Contact'),
        content: TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Enter email address',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Add'),
            onPressed: () async {
              try {
                String contactId = await EmergencyContactPost.addEmergencyContact(
                  1, 
                  _emailController.text
                );
                Navigator.pop(context);
                await loadContacts(); // Reload all contacts to get updated list
                _emailController.clear();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Contact added successfully'))
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add contact'))
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (contacts?.isEmpty ?? true) {
      return Center(
        child: Column(
          children: [
            Text(
              'No emergency contacts added yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add Emergency Contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: _showAddContactDialog,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: contacts!.length,
          itemBuilder: (context, index) {
            final contact = contacts![index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: contact.photo != null 
                    ? NetworkImage(contact.photo!)
                    : null,
                  child: contact.photo == null 
                    ? Icon(Icons.person)
                    : null,
                ),
                title: Text(contact.username ?? 'Unknown'),
                subtitle: Text(contact.email ?? ''),
              ),
            );
          },
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          icon: Icon(Icons.add),
          label: Text('Add More'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: _showAddContactDialog,
        ),
      ],
    );
  }
}
