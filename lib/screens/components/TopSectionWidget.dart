import 'package:flutter/material.dart';
import 'package:nari/screens/NewProfileScreen.dart';
import 'package:nari/bases/UserProvider.dart';

class TopSectionWidget extends StatefulWidget {
  const TopSectionWidget({Key? key}) : super(key: key);

  @override
  _TopSectionWidgetState createState() => _TopSectionWidgetState();
}

class _TopSectionWidgetState extends State<TopSectionWidget> {
  String userName = 'Loading...';
  String userImage = 'assets/images/nariiicon.jpeg';
  String isPremium = 'standardd';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    UserProvider userProvider = UserProvider();
    await userProvider.loadUser();

    if (userProvider.user != null) {
      setState(() {
        userName = userProvider.user!.username ?? '';
        userImage = userProvider.user!.photo as String? ?? '';
        isPremium = userProvider.user!.username ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nari Icon
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/nariiicon.jpeg',
                width: 32,
                height: 32,
              ),
            ),
          ),
          // Profile container
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewProfileScreen()),
              );
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(userImage),
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
