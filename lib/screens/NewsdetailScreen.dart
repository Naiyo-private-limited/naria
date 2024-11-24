import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:action_slider/action_slider.dart';
import 'package:nari/bases/Appthemes.dart';

class NewsDetailScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String image;
  final String description;

  const NewsDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.description,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  void _showCommentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Makes the modal appear higher and more scrollable
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 350, // Increased height for better UI
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modal bar at the top (iOS-like)
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5, // Modern font spacing
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // Comment 1
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(CupertinoIcons.person, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Comment 1: Great news!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Comment 2
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.orangeAccent,
                      child: Icon(CupertinoIcons.person, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Comment 2: Very informative.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Input Field for New Comment (iOS-style)
                CupertinoTextField(
                  placeholder: "Add a comment...",
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row with Back Button and Profile Avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Handle back navigation
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/narii.png'),
                        radius: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Use the dynamic title
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                // Use the dynamic subtitle
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Use the dynamic image from network
                Container(
                  width: screenWidth,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Stack(
                  clipBehavior: Clip
                      .none, // Allow the button to slightly overflow the card
                  children: [
                    // The card with yellow background
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(50), // Rounded card corners
                      ),
                      color:
                          AppThemes.bg1, // Set the background color to yellow
                      child: Padding(
                        padding: const EdgeInsets.all(
                            24.0), // Adjusted padding for a balanced look
                        child: Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    // Positioned transparent circle with a share button at the top-right corner
                    Positioned(
                      right:
                          -5, // Slight overflow to the right to look more dynamic
                      top:
                          -20, // Slight overflow on the top to avoid covering content
                      child: GestureDetector(
                        onTap: () {
                          // Handle share button action
                        },
                        child: Container(
                          width:
                              50, // Adjusted size of the circle for a balanced look
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black
                                .withOpacity(0.6), // Transparent black circle
                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black26, // Subtle shadow for elevation
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.north_east,
                            color: Colors.white, // White share icon
                            size: 24, // Adjusted icon size for clarity
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ActionSlider.standard(
                  width: screenWidth,
                  height: 80,
                  toggleColor: AppThemes.background3,
                  backgroundColor: Colors.grey[300],
                  sliderBehavior: SliderBehavior.stretch,
                  icon: const Icon(
                    Icons.comment,
                    color: Colors.white,
                  ),
                  action: (controller) async {
                    controller.loading(); // Show loading indicator
                    await Future.delayed(
                        const Duration(seconds: 1)); // Simulate delay
                    controller.success(); // Indicate success
                    await Future.delayed(const Duration(
                        milliseconds: 500)); // Wait before showing modal
                    _showCommentModal(); // Show comment modal
                    controller.reset(); // Reset the slider
                  },
                  child: const Text(
                    'Unlock Comment',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
