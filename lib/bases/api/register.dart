// In RegisterAPI.dart
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:nari/bases/UserProvider.dart';
// import 'package:nari/bases/Webservices.dart';

// class RegisterAPI {
// int? id;
//   String? username;
//   String? email;
//   String? photo;
//   String? accountType;
//   String? createdAt;

//   RegisterAPI(
//       {this.id,
//       this.email,
// ,
//       this.createdAt,
//       this.emergencyContacts,
//       this.liveLocationLink,
//       this.photo});

//   RegisterAPI.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     email = json['email'];
//     password = json['password'];
//     updatedAt = json['updatedAt'];
//     createdAt = json['createdAt'];
//     emergencyContacts = json['emergencyContacts'];
//     liveLocationLink = json['liveLocationLink'];
//     photo = json['photo'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['email'] = this.email;
//     data['password'] = this.password;
//     data['updatedAt'] = this.updatedAt;
//     data['createdAt'] = this.createdAt;
//     data['emergencyContacts'] = this.emergencyContacts;
//     data['liveLocationLink'] = this.liveLocationLink;
//     data['photo'] = this.photo;
//     return data;
//   }

// static Future<RegisterAPI> register(
//   BuildContext context,
//   String email,
//   String password,
//   // Add other fields if necessary
// ) async {
//   Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.register}");

//   Map<String, String> body = {
//     'email': email,
//     'password': password,
//     // Include other fields here
//   };

//   try {
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(body),
//     );

//     final responseString = response.body;
//     print(responseString);

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       RegisterAPI registerResponse =
//           RegisterAPI.fromJson(jsonDecode(responseString));
//       return registerResponse;
//     } else {
//       // Handle errors based on your API's error structure
//       throw Exception("Failed to register: ${response.body}");
//     }
//   } catch (e) {
//     print("Error from api: $e");
//     throw e;
//   }
// }
// }
import 'package:nari/bases/UserProvider.dart';
import 'package:nari/bases/Webservices.dart';
import 'package:nari/bases/api/login.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path; // For extracting filename

class RegisterAPI {
  String? message;
  String? token;
  User? user;

  RegisterAPI({this.message, this.token, this.user});

  RegisterAPI.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }

  static Future<RegisterAPI> register(
    BuildContext context,
    String name,
    String email,
    String password,
    File? photo,
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.register}");

    // Create multipart request
    var request = http.MultipartRequest('POST', url);

    // Add text fields
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;

    // Add the photo file to request if provided
    if (photo != null) {
      var stream = http.ByteStream(photo.openRead());
      var length = await photo.length();
      var multipartFile = http.MultipartFile(
        'photo',
        stream,
        length,
        filename: path.basename(photo.path), // Use the file's original name
      );
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      print(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        RegisterAPI registerResponse =
            RegisterAPI.fromJson(jsonDecode(responseString));
        Provider.of<UserProvider>(context, listen: false)
            .saveUser(registerResponse.user!, registerResponse.token!);
        return registerResponse;
      } else {
        throw Exception("Failed to register: $responseString");
      }
    } catch (e) {
      print("Error from API: $e");
      throw e;
    }
  }
}
