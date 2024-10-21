import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nari/bases/Webservices.dart';

// Define the class for video records or other related objects
class VideoRecord {
  int? id;
  String? title;

  VideoRecord({this.id, this.title});

  VideoRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}

class ProfileAPI {
  int? id;
  String? email;
  String? username;
  String? password;
  String? accountType;
  String? emergencyContacts;
  String? liveLocationLink;
  String? photo;
  String? createdAt;
  String? updatedAt;
  List<VideoRecord>? videoRecords;

  ProfileAPI(
      {this.id,
      this.email,
      this.username,
      this.password,
      this.accountType,
      this.emergencyContacts,
      this.liveLocationLink,
      this.photo,
      this.createdAt,
      this.updatedAt,
      this.videoRecords});

  ProfileAPI.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    accountType = json['accountType'];
    emergencyContacts = json['emergencyContacts'];
    liveLocationLink = json['liveLocationLink'];
    photo = json['photo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['VideoRecords'] != null) {
      videoRecords = [];
      json['VideoRecords'].forEach((v) {
        videoRecords!.add(VideoRecord.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['accountType'] = this.accountType;
    data['emergencyContacts'] = this.emergencyContacts;
    data['liveLocationLink'] = this.liveLocationLink;
    data['photo'] = this.photo;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.videoRecords != null) {
      data['VideoRecords'] = this.videoRecords!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // Function to fetch profile by user ID
  static Future<ProfileAPI> fetchProfile(int userId) async {
    try {
      final Uri url =
          Uri.parse("${Webservice.rootURL}/${Webservice.profile}/1");

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseString = response.body;

        // Parse the API response into a ProfileAPI object
        Map<String, dynamic> profileJson = jsonDecode(responseString);
        return ProfileAPI.fromJson(profileJson);
      } else {
        // Handle non-200 response
        throw Exception(
            'Failed to load profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error from API: $e");
      throw e;
    }
  }
}
