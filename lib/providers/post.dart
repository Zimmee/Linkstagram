import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:linkstagram/models/http_exception.dart';
import 'package:linkstagram/models/photo.dart';
import 'package:linkstagram/models/post_comment.dart';
import 'package:linkstagram/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:linkstagram/providers/posts.dart';

class Post with ChangeNotifier {
  int id;
  User author;
  DateTime createdAt;
  bool isLiked;
  int likesCount;
  List<Photo> photos;
  String description;
  List<PostComment> comments = [];

  Post({
    this.author,
    this.createdAt,
    this.id,
    this.isLiked,
    this.likesCount,
    this.photos,
    this.description,
  });

  void setLike(String _token) {
    final url = Uri.https('linkstagram-api.ga', '/posts/$id/like');
    http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: _token
      },
    ).then((value) {
      if (value.statusCode >= 400) {
        throw HttpException('Unable to set like');
      }
      notifyListeners();
    });
  }

  Future<void> getComments() async {
    final url = Uri.https('linkstagram-api.ga', '/posts/$id/comments');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode >= 400) {
      throw HttpException('Unable to get comments');
    }
    comments.clear();
    (json.decode(response.body) as List).forEach((item) {
      final PostComment tmp = PostComment(
          id: item['id'],
          created_at: parseDate(item['created_at'].toString()),
          message: item['message'],
          commenter: User(
              username: item['commenter']['username'],
              description: item['commenter']['description'],
              first_name: item['commenter']['first_name'],
              followers: item['commenter']['followers'],
              following: item['commenter']['following'],
              job_title: item['commenter']['job_title'],
              last_name: item['commenter']['last_name'],
              profile_photo_url: item['commenter']['profile_photo_url']));
      comments.add(tmp);
    });
  }

  Future<int> amountOfComments() async {
    final url = Uri.https('linkstagram-api.ga', '/posts/$id/comments');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode >= 400) {
      throw HttpException('Unable to get comments');
    }
    return (json.decode(response.body) as List).length;
  }

  void deleteLike(String _token) {
    final url = Uri.https('linkstagram-api.ga', '/posts/$id/like');
    http.delete(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: _token
      },
    ).then((value) {
      if (value.statusCode >= 400) {
        throw HttpException('Unable to set like');
      }
      notifyListeners();
    });
  }

  void toggleLike(String _token) {
    final bool oldValue = isLiked;
    final int oldLikeCount = likesCount;
    isLiked = !isLiked;
    notifyListeners();
    try {
      if (oldValue) {
        deleteLike(_token);
        likesCount--;
      } else {
        setLike(_token);
        likesCount++;
      }
    } catch (error) {
      likesCount = oldLikeCount;
      isLiked = oldValue;
      notifyListeners();
    }
  }

  Future<void> createComment(String token, String message) async {
    final url = Uri.https('linkstagram-api.ga', '/posts/$id/comments');
    final body = json.encode({
      'message': message,
    });
    print(body);
    final response = await http.post(
      url,
      body: body,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (response.statusCode >= 400) {
      throw HttpException(response.body != null
          ? json.decode(response.body)['errors']['message'][0]
          : 'Unable to add comment');
    }
    getComments();
    notifyListeners();
  }
}
