import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nari/bases/api/login.dart';
import 'package:nari/screens/NewHomeScreen.dart';
import 'package:nari/screens/components/CustomNotification.dart';

class LoginModal {
  static void showLoginModal(
      BuildContext context, List<CameraDescription> cameras) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> _handleLogin(BuildContext context) async {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill in all fields")),
        );
        return;
      }

      try {
        // Perform login and get response from API
        LoginAPI loginResponse = await LoginAPI.login(context, email, password);

        // Check if login was successful (token received)
        if (loginResponse.token != null) {
          // Notify user about successful login
          CustomNotification.show(context, "Login successful");
          Navigator.pop(context); // Close the modal after success
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NewHomeScreen(
                      cameras: cameras.cast<CameraDescription>(),
                    )),
          );

          // Perform further actions after login (like navigating to another page)
        } else {
          // Notify user of login failure
          CustomNotification.show(context, "Login Failed");
        }
      } catch (e) {
        // Handle errors during login (like network issues)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred during login")),
        );
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Hi User,",
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/images/google.svg',
                                        width: 50,
                                        height: 50,
                                      ),
                                      onPressed: () {
                                        // Add your onPressed functionality
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "Welcome",
                                style: TextStyle(
                                    fontSize: 40, color: Colors.grey[500]),
                              ),
                              Text(
                                "Back",
                                style: TextStyle(
                                    fontSize: 40, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Email TextField
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Password TextField
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            // Trigger the login action
                            _handleLogin(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[900],
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Top Drag Indicator (UI enhancement)
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 110,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
