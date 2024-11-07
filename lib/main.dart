import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:provider/provider.dart';

import 'package:nari/bases/UserProvider.dart';
import 'package:nari/screens/splash_screen.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  // Ensure that Flutter bindings are initialized before calling any plugin code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the cameras
  // cameras = await availableCameras();

  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Nari",
    notificationText: "Live Location Sharing",
    notificationImportance: AndroidNotificationImportance.high,
    enableWifiLock: true,
  );

  bool hasPermissions =
      await FlutterBackground.initialize(androidConfig: androidConfig);

  // Start the app
  if (hasPermissions) {
    
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } else {
    // Close the app
    exit(0);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nari',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(
        cameras: cameras ?? [], // Pass the cameras to the SplashScreen
      ),
      // home: ChatScreen(
      //   chatId: 1,
      // ),
    );
  }
}
