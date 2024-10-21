import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nari/bases/Appthemes.dart';
import 'package:nari/bases/UserProvider.dart';
import 'package:nari/bases/api/login.dart';
import 'package:nari/screens/NewHomescreen.dart';
import 'package:nari/screens/components/CustomNotification.dart';
import 'package:nari/screens/components/LoginModal.dart';
import 'package:nari/screens/components/RegisterModal.dart';
import 'package:provider/provider.dart';

class NewLoginScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const NewLoginScreen({super.key, required this.cameras});

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  @override
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // void _showLoginModal(BuildContext context) {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg2.png', // Replace with your image asset
              fit: BoxFit.fitWidth,
            ),
          ),
          // Custom shape with image inside hollow areas
          FutureBuilder<ui.Image>(
            future: _loadImage('assets/images/bg3.png'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return CustomPaint(
                  size:
                      Size(double.infinity, MediaQuery.of(context).size.height),
                  painter: CustomShapePainter(snapshot.data!),
                );
              } else {
                // Show a loading indicator or nothing until the image is loaded
                return const SizedBox.shrink();
              }
            },
          ),
          // Positioned Login Button on the bottom rectangle
          Positioned(
            left: 30,
            right: 30,
            bottom: MediaQuery.of(context).size.height *
                0.17, // Adjust to position inside the bottom rectangle
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Show login modal when button is pressed
                  LoginModal.showLoginModal(context, widget.cameras);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Text(
                  "Let's Start",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[800]), // Login button text style
                ),
              ),
            ),
          ),
          // Positioned "Don't have an account?" text and Register button below everything
          Positioned(
            bottom: 20,
            left: 30,
            right: 30,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have account?",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle register action
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        // Show login modal when button is pressed
                        RegisterModal.showRegisterModal(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.bg2,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Rounded button corners
                        ),
                      ),
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white, // Register button text color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to load image as a Future
  Future<ui.Image> _loadImage(String asset) async {
    final ByteData data = await rootBundle.load(asset);
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }
}

class CustomShapePainter extends CustomPainter {
  final ui.Image image;

  CustomShapePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    // Define the paint for the solid white background (outside hollow shapes)
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;

    // Create a combined path for the hollow shapes
    final hollowShapes = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(30, 40, size.width - 60, 500),
          const Radius.circular(50))) // Hollow rounded square

      // Funnel shape path with inward curves
      ..moveTo((size.width / 2) - 40, 540) // Top-left of the funnel
      ..quadraticBezierTo((size.width / 2) - 10, 600, (size.width / 2) - 20,
          630) // Left inward curve
      ..lineTo((size.width / 2) + 20, 630) // Bottom of the funnel (narrower)
      ..quadraticBezierTo((size.width / 2) + 10, 600, (size.width / 2) + 40,
          540) // Right inward curve
      ..close(); // Close the path to form a funnel

    // Hollow rounded rectangle below the funnel
    hollowShapes.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(30, 630, size.width - 60, 120),
        const Radius.circular(50)));

    // Step 1: Draw the white background for the entire canvas
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Step 2: Clip the canvas to the hollow shapes and draw the background image inside them
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.clipPath(hollowShapes);

    // Draw the image within the hollow shapes
    paintImage(
      canvas: canvas,
      image: image,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      fit: BoxFit.cover,
    );

    // Restore the canvas after clipping
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
