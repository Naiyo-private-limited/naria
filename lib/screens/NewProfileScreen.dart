import 'package:flutter/material.dart';
import 'package:nari/bases/api/profile.dart';
import 'package:nari/screens/NewLoginScreen.dart';
import 'package:nari/screens/components/EmergencyContactsScreen.dart';
import 'package:nari/screens/components/video_list_widget.dart';
import 'package:nari/screens/map_screen.dart';
import 'package:provider/provider.dart';
import 'package:nari/bases/UserProvider.dart';

class NewProfileScreen extends StatefulWidget {
  const NewProfileScreen({super.key});

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  ProfileAPI? userProfile;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  void getUserProfile() async {
    int userId = 1; // Example user ID
    try {
      ProfileAPI profile = await ProfileAPI.fetchProfile(userId);
      setState(() {
        userProfile = profile;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch profile';
        isLoading = false;
      });
      print('Failed to fetch profile: $e');
    }
  }

  void _handleLogout() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.clearUser();
    // Navigate to login screen and clear all previous routes
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewLoginScreen(cameras: [],)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top greeting with settings and home buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        userProfile != null
                            ? Text(
                                "Hi ${userProfile!.username},",
                                style: TextStyle(
                                  fontSize: userProfile!.username!.length > 15
                                      ? 20
                                      : 30,
                                  color: Colors.grey[800],
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              )
                            : Text(
                                "Hi,",
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.grey[800],
                                ),
                              ),
                        Row(
                          children: [
                            // CircleAvatar(
                            //   backgroundColor: Colors.white,
                            //   child: IconButton(
                            //     icon: Icon(Icons.map, color: Colors.grey[500]),
                            //     onPressed: () {
                            //       // Add your onPressed functionality
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => UberMapScreen(),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: Icon(Icons.home, color: Colors.grey[800]),
                                onPressed: () {
                                  // Add your onPressed functionality
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Text(
                      "Welcome",
                      style: TextStyle(fontSize: 40, color: Colors.grey[500]),
                    ),
                    Text(
                      "Home!",
                      style: TextStyle(fontSize: 40, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Emergency Contact Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Emergency Contact",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const EmergencyContactsWidget(), // Use the widget here

                const SizedBox(height: 20),

                // // Emergency Contact Section
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                //   decoration: BoxDecoration(
                //     color:
                //         Colors.transparent, // Make the background transparent
                //     borderRadius: BorderRadius.circular(30), // Rounded edges
                //     border: Border.all(
                //       color: Colors.black, // Border color
                //       width: 2, // Border width
                //     ),
                //   ),
                //   child: const Text(
                //     "Liked Posts", // Corrected text to "Emergency Contact"
                //     style: TextStyle(
                //       fontSize: 12,
                //       color: Colors.black, // Text color matches the border
                //     ),
                //   ),
                // ),

                // const SizedBox(height: 10),

                // // Scrollable images for Liked Posts
                // SizedBox(
                //   height: 100, // Set height for the images
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: List.generate(5, (index) {
                //       return Container(
                //         margin: const EdgeInsets.only(right: 10),
                //         width: 100,
                //         decoration: BoxDecoration(
                //           color: Colors.grey[900],
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         child: const Icon(Icons.image, size: 50),
                //       );
                //     }),
                //   ),
                // ),
                // const SizedBox(height: 20),

                // Emergency Contact Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color:
                        Colors.transparent, // Make the background transparent
                    borderRadius: BorderRadius.circular(30), // Rounded edges
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 2, // Border width
                    ),
                  ),
                  child: const Text(
                    "My Videoes", // Corrected text to "Emergency Contact"
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black, // Text color matches the border
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const VideoListWidget(), // Use the reusable video list widget here

                const SizedBox(height: 40),

                // Logout Button
                Center(
                  child: Container(
                    width: screenWidth * 0.8,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
