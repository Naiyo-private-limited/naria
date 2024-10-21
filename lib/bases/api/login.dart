import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nari/bases/UserProvider.dart';
import 'package:nari/bases/Webservices.dart';
import 'package:provider/provider.dart';

class LoginAPI {
  String? message;
  String? token;
  User? user;

  LoginAPI({this.message, this.token, this.user});

  LoginAPI.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }

  static Future<LoginAPI> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.login}");

    Map<String, String> body = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseString = response.body;
      print(responseString);

      LoginAPI loginResponse = LoginAPI.fromJson(jsonDecode(responseString));

      if (loginResponse.token != null && loginResponse.user != null) {
        // Save user and token using UserProvider
        Provider.of<UserProvider>(context, listen: false)
            .saveUser(loginResponse.user!, loginResponse.token!);
      }

      return loginResponse;
    } catch (e) {
      print("Error from api login: $e");
      throw e;
    }
  }
}

class User {
  int? id;
  String? username;
  String? email;
  List<String>? emergencyContacts;
  String? liveLocationLink;
  String? photo;
  String? createdAt;

  User(
      {this.id,
      this.username,
      this.email,
      this.emergencyContacts,
      this.liveLocationLink,
      this.photo,
      this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    // Handle null for emergencyContacts safely
    emergencyContacts = json['emergencyContacts'] != null
        ? List<String>.from(json['emergencyContacts'])
        : null;
    liveLocationLink = json['liveLocationLink'];
    photo = json['photo'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['emergencyContacts'] = this.emergencyContacts;
    data['liveLocationLink'] = this.liveLocationLink;
    data['photo'] = this.photo;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
