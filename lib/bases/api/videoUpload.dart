import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nari/bases/Webservices.dart';
import 'package:path/path.dart';

class VideoUploadAPI {
  String? message;
  Video? video;

  VideoUploadAPI({this.message, this.video});

  VideoUploadAPI.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    return data;
  }

  static Future<void> videoUpload(
    BuildContext context,
    String userId,
    File video, // Use File to represent the video file
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.videoupload}");

    try {
      // Ensure the file exists
      if (!video.existsSync()) {
        throw Exception("File not found at the specified path: ${video.path}");
      }

      // Create a multipart request
      var request = http.MultipartRequest('POST', url);

      // Add fields
      request.fields['userId'] =
          userId; // Make sure 'userId' is what API expects

      // Read the video file as a byte stream
      var videoStream = http.ByteStream(video.openRead());
      var videoLength = await video.length();
      var videoMultipartFile = http.MultipartFile(
        'video', // Ensure this field name is what your API expects
        videoStream,
        videoLength,
        filename: basename(video.path), // Extract the filename
      );

      // Add the video file to the request
      request.files.add(videoMultipartFile);

      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseString = await response.stream.bytesToString();
        print("Upload successful: $responseString");
      } else {
        // Handle the error response from the server
        var responseString = await response.stream.bytesToString();
        print("Failed to upload video: $responseString");
        throw Exception("Failed to upload video: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error from API: $e");
      throw e;
    }
  }
}

class Video {
  int? id;
  String? url;
  int? userId;
  int? duration;
  String? updatedAt;
  String? createdAt;

  Video({
    this.id,
    this.url,
    this.userId,
    this.duration,
    this.updatedAt,
    this.createdAt,
  });

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    userId = json['userId'];
    duration = json['duration'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['userId'] = this.userId;
    data['duration'] = this.duration;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    data['UserId'] = this.userId;
    return data;
  }
}
