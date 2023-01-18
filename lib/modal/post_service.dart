import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiService {
  Future<String> getResponseBody() async {
    await Future.delayed(Duration(milliseconds: 500));
    //! No Internet Connection
    // throw const SocketException('No Internet');
    //! 404
    throw HttpException('404');
    //! Invalid JSON (throws FormatException)
    // return 'abcd';
    // return '{"userId":1,"title":"Result","body":"First result"}';
  }
}

class PostService {
  final httpClient = ApiService();
  Future<PostModal> getOnePost() async {
    // The WORST type of error handling.
    // There's no way to get these error messages to the UI.
    try {
      final responseBody = await httpClient.getResponseBody();
      return PostModal.fromJson(responseBody);
    } on SocketException {
      throw Failure(message: "No Internet Connection");
    }on HttpException{
      throw Failure(message: "Internal Issue Occured");
    }on FormatException{
      throw Failure(message: "Bad Response");
    }
  }
}

class PostModal {
  final int userId;
  final String title;
  final String body;

  PostModal({
    required this.userId,
    required this.title,
    required this.body,
  });

  static PostModal fromMap(Map<String, dynamic> map) {
    return PostModal(
      userId: map['userId'],
      title: map['title'],
      body: map['body'],
    );
  }

  static PostModal fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'userId: $userId, title: $title, body: $body';
  }
}

class Failure {
  final String message;
  Failure({required this.message});

  @override
  String toString() {
    return message;
  }
}
