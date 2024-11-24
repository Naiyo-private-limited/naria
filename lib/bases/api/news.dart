import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nari/bases/Webservices.dart';

class NewsAPI {
  int? id;
  String? title;
  String? description;
  String? photo;
  String? createdAt;
  String? updatedAt;
  String? categories;
  List<Comments>? comments;

  NewsAPI(
      {this.id,
      this.title,
      this.description,
      this.photo,
      this.createdAt,
      this.updatedAt,
      this.categories,
      this.comments});

  NewsAPI.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    photo = json['photo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    categories = json['categories'];
    if (json['Comments'] != null) {
      comments = <Comments>[];
      json['Comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['photo'] = this.photo;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['categories'] = this.categories;
    if (this.comments != null) {
      data['Comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Future<List<NewsAPI>> fetchNews() async {
    try {
      final Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.news}");

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseString = response.body;

        // Parse the API response into a list of NewsAPI objects
        List<dynamic> newsJsonList = jsonDecode(responseString);
        List<NewsAPI> newsList =
            newsJsonList.map((json) => NewsAPI.fromJson(json)).toList();

        return newsList;
      } else {
        // Handle non-200 response
        throw Exception(
            'Failed to load news. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error from API: $e");
      throw e;
    }
  }
}

class Comments {
  int? id;
  String? content;
  String? createdAt;
  String? updatedAt;
  int? articleId;
  int? userId;

  Comments(
      {this.id,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.articleId,
      this.userId});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    articleId = json['ArticleId'];
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['ArticleId'] = this.articleId;
    data['UserId'] = this.userId;
    return data;
  }
}
