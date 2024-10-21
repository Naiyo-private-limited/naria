import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nari/bases/Webservices.dart';

class EmergencyContactAPI {
  List<String>? emergencyContacts;

  EmergencyContactAPI({this.emergencyContacts});

  EmergencyContactAPI.fromJson(Map<String, dynamic> json) {
    emergencyContacts = List<String>.from(json['emergencyContacts']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emergencyContacts'] = this.emergencyContacts;
    return data;
  }

  Future<List<String>?> emergencyGet() async {
    try {
      final Uri url =
          Uri.parse("${Webservice.rootURL}/${Webservice.emergency}");

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseString = response.body;
        final jsonResponse = jsonDecode(responseString);
        return List<String>.from(jsonResponse['emergencyContacts']);
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
