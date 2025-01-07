import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nari/bases/Appthemes.dart';
import 'package:nari/screens/NewsdetailScreen.dart';
import 'package:nari/screens/SOSScreen.dart';
import 'package:nari/screens/components/ModernFormModal.dart';
import 'package:nari/screens/components/NewsListPage.dart';
import 'package:nari/screens/components/TopSectionWidget.dart';
import 'package:nari/screens/components/emergency_contact_form.dart';
import 'package:nari/screens/components/news_card.dart';

class NewHomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const NewHomeScreen({super.key, required this.cameras});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  final List<String> carouselImages = [
    'assets/images/britania.webp',
    'assets/images/britania.webp',
    'assets/images/britania.webp',
  ];
  // Variables for floating button position
  double xPos = 20.0;
  double yPos = 600.0;
  bool isDragging = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Get device screen size for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[300], // Subtle background color
      body: SafeArea(
        child: Stack(
          children: [
            // Replace existing menu button with this
            Positioned(
              left: 16,
              top: 16,
              child: IconButton(
                icon: Icon(Icons.menu, color: AppThemes.bg2),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            // Scrollable content below the fixed header
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Fill width
                  children: [
                    const SizedBox(height: 10),

                    // Carousel slider with rounded corners
                    CarouselSlider(
                      options: CarouselOptions(
                        height: screenHeight * 0.20,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                      ),
                      items: carouselImages.map((imagePath) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: screenWidth,
                          ),
                        );
                      }).toList(),
                    ),

                    // Categories title
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 58,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),

                    // News card widget
                    const NewsListPage()
                  ],
                ),
              ),
            ),

            // Fixed TopSectionWidget
            const TopSectionWidget(),
            // Draggable Floating SOS Button
            Positioned(
              left: xPos,
              top: yPos,
              child: GestureDetector(
                onPanStart: (_) {
                  setState(() {
                    isDragging = true;
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    xPos += details.delta.dx;
                    yPos += details.delta.dy;
                  });
                },
                onPanEnd: (_) {
                  setState(() {
                    isDragging = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SOSScreen(
                              widget.cameras), // Pass available cameras
                        ),
                      );
                    },
                    child: const Icon(Icons.warning_rounded,
                        color: AppThemes.background),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppThemes.bg2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          _showAnimatedModal(context);
        },
        child: Icon(Icons.add, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAnimatedModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (_, controller) {
              return EmergencyContactForm(
                onSubmit: (contactData) async {
                  try {
                    // TODO: Replace with your actual API endpoint
                    // final response = await http.post(
                    //   Uri.parse('your-api-endpoint'),
                    //   body: contactData,
                    // );
                    
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact saved successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
