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
  XFile? recordedVideo;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      initializeCameraAndStartRecording();
    } else {
      setState(() {
        errorMessage =
            "Camera permission denied. Please enable it in settings.";
      });
    }
  }

  Future<void> initializeCameraAndStartRecording() async {
    try {
      CameraDescription? rearCamera;

      for (var camera in widget.cameras) {
        if (camera.lensDirection == CameraLensDirection.back) {
          rearCamera = camera;
        }
      }

      if (rearCamera != null) {
        rearCameraController = CameraController(
          rearCamera,
          ResolutionPreset.high,
          enableAudio: true,
        );
        await rearCameraController!.initialize();
        startRecording();
      } else {
        setState(() {
          errorMessage = "Rear camera not available.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error initializing camera: $e";
      });
    }
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
      setState(() {
        errorMessage = "Error starting video recording: $e";
      });
    }
  }

  Future<void> stopRecordingAndUpload() async {
    try {
      if (rearCameraController != null &&
          rearCameraController!.value.isRecordingVideo) {
        recordedVideo = await rearCameraController!.stopVideoRecording();

        if (recordedVideo != null) {
          await uploadVideo(File(recordedVideo!.path));
        }
      }

      setState(() {
        isRecording = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error stopping video recording: $e";
      });
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

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Video uploaded successfully!'),
          backgroundColor: Colors.green,
        ));
      } else {
        setState(() {
          errorMessage = "User ID not found. Please log in again.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to upload video: $e";
      });
    }
  }

  Future<String> getUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('user');
      if (userData != null) {
        var user = jsonDecode(userData);
        return user['id'].toString();
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error retrieving user ID: $e";
      });
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            if (rearCameraController == null ||
                !rearCameraController!.value.isInitialized)
              Expanded(
                child: Center(
                  child: errorMessage.isNotEmpty
                      ? Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        )
                      : CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CameraPreview(rearCameraController!),
                ),
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
          disabledBackgroundColor: Colors.grey.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            isRecording ? "Stop and Upload" : "Recording Stopped",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
