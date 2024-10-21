import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:nari/bases/api/videoUpload.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SOSScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  SOSScreen(this.cameras);

  @override
  _SOSScreenState createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  CameraController? rearCameraController;
  bool isRecording = false;
  XFile? recordedVideo; // This will store the recorded video file

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
    initializeCameraAndStartRecording();
  }

  Future<void> initializeCameraAndStartRecording() async {
    CameraDescription? rearCamera;

    for (var camera in widget.cameras) {
      if (camera.lensDirection == CameraLensDirection.back) {
        rearCamera = camera;
      }
    }

    if (rearCamera != null) {
      rearCameraController = CameraController(
        rearCamera!,
        ResolutionPreset.high,
        enableAudio: true,
      );
      await rearCameraController!.initialize();

      // Start recording when initialized
      startRecording();
    }

    setState(() {});
  }

  Future<void> startRecording() async {
    try {
      if (rearCameraController != null &&
          !rearCameraController!.value.isRecordingVideo) {
        await rearCameraController!.startVideoRecording();

        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print("Error starting video recording: $e");
    }
  }

  Future<void> stopRecordingAndUpload() async {
    try {
      if (rearCameraController != null &&
          rearCameraController!.value.isRecordingVideo) {
        // Get the XFile from the stopVideoRecording() result
        recordedVideo = await rearCameraController!.stopVideoRecording();

        if (recordedVideo != null) {
          // Upload the video after recording
          await uploadVideo(File(recordedVideo!.path));
        }
      }

      setState(() {
        isRecording = false;
      });
    } catch (e) {
      print("Error stopping video recording: $e");
    }
  }

  Future<void> uploadVideo(File videoFile) async {
    try {
      String userId = await getUserId();
      if (userId.isNotEmpty) {
        await VideoUploadAPI.videoUpload(
          context,
          userId,
          videoFile,
        );

        // Show success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Video uploaded successfully!'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      print('Failed to upload video: $e');
    }
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    if (userData != null) {
      var user = jsonDecode(userData);
      return user['id'].toString();
    }
    return "";
  }

  @override
  void dispose() {
    rearCameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (rearCameraController == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: rearCameraController != null &&
                      rearCameraController!.value.isInitialized
                  ? CameraPreview(rearCameraController!)
                  : Center(child: Text("Rear Camera Not Available")),
            ),
            SizedBox(height: 20),
            _buildStopButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStopButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: isRecording ? stopRecordingAndUpload : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          "Stop and Upload",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
