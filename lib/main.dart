import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nari/screens/NewHomeScreen.dart';
import 'package:nari/screens/NewLoginScreen.dart';
import 'package:nari/screens/home_screen.dart';
import 'package:nari/screens/map_screen.dart';
import 'package:nari/screens/splash_screen.dart';
import 'package:nari/bases/UserProvider.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  // Ensure that Flutter bindings are initialized before calling any plugin code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the cameras
  cameras = await availableCameras();

  // Start the app
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
