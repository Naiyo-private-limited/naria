import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nari/bases/Webservices.dart';

class EmergencycontactDetailsAPI {
  List<EmergencyContacts>? emergencyContacts;

  EmergencycontactDetailsAPI({this.emergencyContacts});

  EmergencycontactDetailsAPI.fromJson(Map<String, dynamic> json) {
    if (json['emergencyContacts'] != null) {
      emergencyContacts = <EmergencyContacts>[];
      json['emergencyContacts'].forEach((v) {
        emergencyContacts!.add(new EmergencyContacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.emergencyContacts != null) {
      data['emergencyContacts'] =
          this.emergencyContacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmergencyContacts {
  int? id;
  String? email;
  String? username;
  String? photo;

  EmergencyContacts({this.id, this.email, this.username, this.photo});

  EmergencyContacts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['photo'] = this.photo;
    return data;
  }

  Future<List<EmergencyContacts>?> emergencydetailsGet() async {
    try {
      final Uri url =
          Uri.parse("${Webservice.rootURL}/${Webservice.emergencydetails}");

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseString = response.body;
        final jsonResponse = jsonDecode(responseString);

        if (jsonResponse['emergencyContacts'] != null) {
          // Convert the JSON response to a list of EmergencyContacts
          List<EmergencyContacts> contacts =
              (jsonResponse['emergencyContacts'] as List)
                  .map((contact) => EmergencyContacts.fromJson(contact))
                  .toList();
          return contacts;
        } else {
          return []; // Return an empty list if no emergency contacts are found
        }
      } else {
        // Handle non-200 response
        throw Exception(
            'Failed to load emergency contacts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error from API: $e");
      throw e;
    }
  }
}
