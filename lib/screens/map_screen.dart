import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
// For Firebase Authentication

class UberMapScreen extends StatefulWidget {
  const UberMapScreen({super.key});

  @override
  State<UberMapScreen> createState() => _UberMapScreenState();
}

class _UberMapScreenState extends State<UberMapScreen> {
  // late GoogleMapController mapController;
  // LatLng _initialPosition =
  //     const LatLng(40.7128, -74.0060); // New York coordinates (default)
  bool _isMapReady = false;
  bool _locationPermissionGranted = false;
  // Set<Marker> _markers = {}; // To store markers for nearby services
  // DatabaseReference? _locationRef; // Firebase database reference
  Stream<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _initializeFirebaseDatabase();
  }

  // Initialize Firebase Realtime Database
  Future<void> _initializeFirebaseDatabase() async {
    // await Firebase.initializeApp();
    // _locationRef = FirebaseDatabase.instance.ref().child('live_location');
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      setState(() {
        _locationPermissionGranted = true;
      });
      _startGeoTracking(); // Start tracking location if permission is granted
    } else if (status.isDenied || status.isPermanentlyDenied) {
      if (await Permission.location.request().isGranted) {
        setState(() {
          _locationPermissionGranted = true;
        });
        _startGeoTracking();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission is required to show the map'),
          ),
        );
      }
    }
  }

  Future<void> _startGeoTracking() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      // _initialPosition = LatLng(position.latitude, position.longitude);
    });

    _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 10));

    _positionStream?.listen((Position position) {
      _updateLocationInFirebase(position); // Update position in Firebase
      setState(() {
        // _initialPosition = LatLng(position.latitude, position.longitude);
      });
      _moveCameraToLocation();
    });
  }

// Update user's live location in Firebase
  Future<void> _updateLocationInFirebase(Position position) async {
    // User? user = FirebaseAuth.instance.currentUser; // Get the current user
    // if (user != null) {
    //   String userId = user.uid; // Get user's UID
    //   _locationRef?.child(userId).set({
    //     'latitude': position.latitude,
    //     'longitude': position.longitude,
    //     'timestamp': DateTime.now().millisecondsSinceEpoch,
    //   });
    // } else {
    //   print("User not authenticated.");
    // }
  }

  void _moveCameraToLocation() {
    if (_isMapReady) {
      // mapController.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(target: _initialPosition, zoom: 15.0),
      // ),
      // );
    }
  }

// Share live location link
//   Future<void> _shareLiveLocation() async {
//     // User? user = FirebaseAuth.instance.currentUser; // Get the current user
//     if (user != null) {
//       String userId = user.uid; // Get user's UID
//       final String liveLocationUrl =
//           'https://nariii-default-rtdb.firebaseio.com/live_location/$userId.json';

//       final String message = '''
// 🚩 *Check out my live location!* ̰

// Company: **NARIII**

// Live Location: $liveLocationUrl

// ''';

//       try {
//         await Share.share(
//           message,
//           subject: 'Shared Live Location from Your Company',
//         );
//       } catch (e) {
//         print('Error sharing location: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not share the location')),
//         );
//       }
//     } else {
//       print("User not authenticated.");
//     }
//   }

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  //   setState(() {
  //     _isMapReady = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // _locationPermissionGranted
          // ? GoogleMap(
          //     onMapCreated: _onMapCreated,
          //     initialCameraPosition: CameraPosition(
          //       target: _initialPosition,
          //       zoom: 15.0,
          //     ),
          //     zoomControlsEnabled: false,
          //     myLocationEnabled: true,
          //     myLocationButtonEnabled: false,
          //     mapType: MapType.normal,
          //     markers: _markers,
          //   )
          // : const Center(child: Text('Requesting Location Permission...')),

          // Floating button for current location
          Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap: () {
                _startGeoTracking();
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: const Icon(Icons.my_location, color: Colors.black),
              ),
            ),
          ),
          // Floating button for current location
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Handle back navigation
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),

          // Bottom container for Uber-like buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 0.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Search nearby services',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              // Handle search logic here
                              print('Searching for: $value');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('GeoTracking',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.health_and_safety,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Safe',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.delivery_dining,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Current Loc.',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
