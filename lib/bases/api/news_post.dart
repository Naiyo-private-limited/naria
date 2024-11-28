import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nari/bases/Webservices.dart';

class NewsPost {
  int? id;
  String? title;
  String? description;
  String? categories;
  String? photo;
  String? updatedAt;
  String? createdAt;

  NewsPost(
      {this.id,
      this.title,
      this.description,
      this.categories,
      this.photo,
      this.updatedAt,
      this.createdAt});

  NewsPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    categories = json['categories'];
    photo = json['photo'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['categories'] = categories;
    data['photo'] = photo;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    return data;
  }

  /// Unified function to post news with optional image
  Future<NewsPost?> postNews({String? imagePath}) async {
    try {
      final Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.newpost}");

      http.MultipartRequest request = http.MultipartRequest('POST', url)
        ..fields['title'] = title ?? ''
        ..fields['description'] = description ?? ''
        ..fields['categories'] = categories ?? '';

      if (imagePath != null && File(imagePath).existsSync()) {
        request.files
            .add(await http.MultipartFile.fromPath('media', imagePath));
      }

      // Send the request
      final response = await request.send();

      // Debug logs
      print('Request URL: $url');
      print('Request Fields: ${request.fields}');
      if (imagePath != null) {
        print('Request File: $imagePath');
      }

      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        print('Response Body: $responseBody');
        final result = NewsPost.fromJson(jsonDecode(responseBody));
        return result;
      } else {
        final errorBody = await response.stream.bytesToString();
        print('Error Response Body: $errorBody');
        print('Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception occurred while posting news: $e');
      return null;
    }
  }
}
