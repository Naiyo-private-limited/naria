import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nari/bases/UserProvider.dart'; // Assuming this has hasUser() function
import 'package:nari/screens/NewHomeScreen.dart';

import 'package:nari/screens/NewLoginScreen.dart';
import 'package:nari/screens/home_screen.dart'; // Replace with actual home screen

class SplashScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SplashScreen({super.key, required this.cameras});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(); // Repeat the animation indefinitely

    checkUser();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  Future<void> checkUser() async {
    UserProvider authService = UserProvider();
    bool userExists = await authService.hasUser();
    setState(() {
      isLoggedIn = userExists;
    });

    // After 3 seconds, navigate to the appropriate screen
    Future.delayed(Duration(seconds: 1), () {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  NewHomeScreen(cameras: widget.cameras)), // Navigate to home
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  NewLoginScreen(cameras: widget.cameras)), // Navigate to login
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(_controller.value *
                  2.0 *
                  3.1416), // Full 360-degree spin on the vertical axis
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Rounded edges
                child: Image.asset(
                  'assets/images/nariii-removebg-preview.png', // Replace with your image path
                  width: 200.0, // Width of the image
                  height: 200.0, // Height of the image
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
