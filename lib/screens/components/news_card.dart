import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nari/screens/NewsdetailScreen.dart';

class NewsCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final Function onTap;
  final String title; // Accept title
  final String imageUrl; // Accept image URL
  final String description; // Accept description

  const NewsCard({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.onTap,
    required this.title, // Add title parameter
    required this.imageUrl, // Add image URL parameter
    required this.description, // Add description parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailScreen(
                title: '$title',
                subtitle: '$title',
                image: '$imageUrl', // Example image path
                description: '$description',
              ),
            ),
          );
        },

        // Execute onTap function when tapped
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          width: screenWidth * 0.9, // Adjust width based on screen size
          height: screenHeight * 0.4, // Responsive height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Rounded edges
            image: DecorationImage(
              image: imageUrl.startsWith('http')
                  ? NetworkImage(imageUrl)
                  : AssetImage(imageUrl)
                      as ImageProvider, // Load network or asset image
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Softer shadow
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Semi-transparent white overlay for modern feel
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              // Share button at the right with larger container and smaller icon
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 55, // Increased size of container
                  height: 55, // Increased size of container
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7), // Darker background
                    shape: BoxShape.circle, // Circle shape
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.north_east,
                    color: Colors.white,
                    size: 20, // Smaller icon
                  ),
                ),
              ),

              Positioned(
                top: 20,
                left: 20,
                child: Text(
                  title.length > 14
                      ? '${title.substring(0, 14)}...'
                      : title, // Truncate if longer than 14
                  style: TextStyle(
                    fontSize: 28, // Slightly smaller font for modern feel
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for contrast
                    shadows: [
                      Shadow(
                        blurRadius: 6.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // Love icon button at the bottom right with larger container and smaller icon
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  width: 55, // Larger container for love icon
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 24, // Smaller icon size
                  ),
                ),
              ),

              // Comment button at the bottom left with larger container and smaller icon
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  width: 55, // Larger container for comment button
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.comment,
                    color: Colors.blue,
                    size: 24, // Smaller icon size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
