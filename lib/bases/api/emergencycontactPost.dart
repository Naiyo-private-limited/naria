import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nari/bases/Webservices.dart';

class EmergencyContactPost {
  static Future<String> addEmergencyContact(int userId, String email) async {
    try {
      final Uri url = Uri.parse("${Webservice.rootURL}/users/$userId/emergency-contacts");
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email
        })
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['emergencyContacts'][0]; // Return the contact ID
      } else {
        throw Exception('Failed to add emergency contact: ${response.statusCode}');
      }
    } catch (e) {
      print("Error adding emergency contact: $e");
      throw e;
    }
  }
}