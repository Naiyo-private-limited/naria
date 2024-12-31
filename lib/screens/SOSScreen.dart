import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:nari/bases/api/videoUpload.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class SOSScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  SOSScreen(this.cameras);

  @override
  _SOSScreenState createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> with WidgetsBindingObserver {
  CameraController? rearCameraController;
  bool isRecording = false;
  XFile? recordedVideo;
  String errorMessage = "";
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await requestCameraPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
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
    setState(() {
      isUploading = true;
    });
    
    try {
      if (rearCameraController != null &&
          rearCameraController!.value.isRecordingVideo) {
        recordedVideo = await rearCameraController!.stopVideoRecording();

        if (recordedVideo != null) {
          await uploadVideo(File(recordedVideo!.path));
          _showSuccessDialog();
        }
      }

      setState(() {
        isRecording = false;
        isUploading = false;
      });
    } catch (e) {
      setState(() {
        isUploading = false;
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

  void _showSuccessDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Success'),
          content: Text('Your emergency video has been uploaded successfully.'),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
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
            _buildHeader(),
            if (rearCameraController == null ||
                !rearCameraController!.value.isInitialized)
              _buildLoadingOrError()
            else
              _buildCameraPreview(),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Emergency Recording',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoadingOrError() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: errorMessage.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.exclamationmark_circle,
                        color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : CupertinoActivityIndicator(radius: 20),
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 2),
        ),
        clipBehavior: Clip.hardEdge,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: CameraPreview(rearCameraController!),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          if (isUploading)
            Column(
              children: [
                CupertinoActivityIndicator(radius: 15),
                SizedBox(height: 16),
                Text(
                  'Uploading video...',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          SizedBox(height: 16),
          CupertinoButton(
            onPressed: isRecording ? stopRecordingAndUpload : null,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            color: isRecording ? Colors.red : Colors.grey.shade800,
            borderRadius: BorderRadius.circular(30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isRecording ? CupertinoIcons.stop_fill : CupertinoIcons.circle_fill,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  isRecording ? "Stop Recording" : "Recording Stopped",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
