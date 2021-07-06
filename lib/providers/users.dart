import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linkstagram/models/user.dart';

class Users with ChangeNotifier {
  final _baseUrl = 'linkstagram-api.ga';
  List<User> _allUsers = [];

  Users() {}

  Users update(String token, Users previousData) {
    _allUsers = previousData._allUsers;
    return this;
  }

  List<User> get users => [..._allUsers];

  Future<void> getAllUsers() async {
    final url = Uri.https(_baseUrl, '/profiles');
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final response = await http.get(url, headers: headers);
    var userMap = json.decode(response.body);
    (userMap as List).forEach((user) {
      _allUsers.add(User(
          username: user['username'],
          description: user['description'],
          first_name: user['first_name'],
          followers: user['followers'],
          following: user['following'],
          job_title: user['job_title'],
          last_name: user['last_name'],
          profile_photo_url: user['profile_photo_url']));
    });
    notifyListeners();
  }
}
