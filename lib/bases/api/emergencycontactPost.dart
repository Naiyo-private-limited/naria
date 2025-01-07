import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nari/bases/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyContactPost {
  static Future<String> addEmergencyContact(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${Webservice.rootURL}/emergency-contacts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getAuthToken()}',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['id'] ?? '';
      } else {
        throw Exception('Failed to add contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding contact: $e');
    }
  }

  static Future<String> getAuthToken() async {
    // Get token from shared preferences or wherever it's stored
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }
}