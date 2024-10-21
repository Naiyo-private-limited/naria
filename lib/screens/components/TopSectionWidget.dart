import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'package:nari/screens/NewProfileScreen.dart';
import 'package:nari/bases/UserProvider.dart'; // Assuming this is where UserProvider and User are defined

class TopSectionWidget extends StatefulWidget {
  const TopSectionWidget({Key? key}) : super(key: key);

  @override
  _TopSectionWidgetState createState() => _TopSectionWidgetState();
}

class _TopSectionWidgetState extends State<TopSectionWidget> {
  String userName = 'Loading...';
  String userImage = 'assets/images/nari.png'; // Default image
  String isPremium = 'standardd';

  @override
  void initState() {
    super.initState();
    loadUserData(); // Load user data when the widget is initialized
  }

  Future<void> loadUserData() async {
    UserProvider userProvider = UserProvider();
    await userProvider.loadUser();

    if (userProvider.user != null) {
      setState(() {
        userName = userProvider.user!.username ?? '';
// Assuming the User model has a 'name' field
        userImage = userProvider.user!.photo as String? ??
            ''; // Assuming there's a profileImage field
        isPremium = userProvider.user!.username ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out icons
        children: [
          // Menu icon
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Background color for the icon
              ),
              child: Center(
                child: Icon(
                  Icons.menu,
                  color: Colors.grey[600],
                  size: 32,
                ),
              ),
            ),
          ),
          // Profile container
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewProfileScreen()),
                );
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white, // Profile container background color
                  borderRadius: BorderRadius.circular(30), // Rounded edges
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Softer shadow
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Subtle shadow effect
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(userImage), // Use user image
                      radius: 20,
                    ),
                    const SizedBox(width: 8),
                    // Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      // children: [
                        Text(
                          userName, // User name
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                            fontSize: 14,
                          ),
                        ),
                        // Text(
                        //   isPremium,
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     color: Colors.grey[600],
                        //   ),
                        // ),
                      // ],
                    // ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
