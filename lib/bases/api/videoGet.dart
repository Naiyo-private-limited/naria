import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nari/bases/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoGetAPI {
  List<Videos>? videos;

  VideoGetAPI({this.videos});

  VideoGetAPI.fromJson(Map<String, dynamic> json) {
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // Function to load user ID and fetch videos
  Future<VideoGetAPI> fetchVideosForUser() async {
    try {
      // Load user ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('user');
      if (userData != null) {
        // Parse user data to get the user ID
        Map<String, dynamic> user = jsonDecode(userData);
        int userId = user['id'];

        // Call the API with the user ID
        final Uri url =
            Uri.parse("${Webservice.rootURL}/api/videos/videos/${userId}");

        final response = await http.get(
          url,
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final responseString = response.body;
          print(responseString);

          // Parse the API response
          VideoGetAPI videoList =
              VideoGetAPI.fromJson(jsonDecode(responseString));
          return videoList;
        } else {
          // Handle non-200 response
          throw Exception(
              'Failed to load videos. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception('User data not found in local storage');
      }
    } catch (e) {
      print("Error from API: $e");
      throw e;
    }
  }
}

class Videos {
  int? id;
  String? url;
  int? duration;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Videos({
    this.id,
    this.url,
    this.duration,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    duration = json['duration'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['duration'] = this.duration;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
