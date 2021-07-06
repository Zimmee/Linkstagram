import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'dart:io';
import 'package:universal_html/js.dart' as js;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linkstagram/models/http_exception.dart';
import 'package:linkstagram/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  final String _baseUrl = 'linkstagram-api.ga';
  String _token;
  User _user;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  User get user {
    return _user;
  }

  Future<int> signUp(String login, String username, String password) async {
    final url = Uri.https(_baseUrl, '/create-account');
    final body = jsonEncode({
      'username': username,
      'login': login,
      'password': password,
    });
    try {
      final response = await http.post(
        url,
        body: body,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode >= 400) {
        throw HttpException(json.decode(response.body)['error']);
      }
      if (response.body.isNotEmpty) {
        print(json.decode(response.body));
      }
      return response.statusCode;
    } catch (error) {
      rethrow;
    }
  }

  Future<int> login(String login, String password) async {
    final url = Uri.https(_baseUrl, '/login');
    final body = jsonEncode({
      'login': login,
      'password': password,
    });
    final response = await http.post(
      url,
      body: body,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    );
    if (response.body.isNotEmpty) {
      _token = response.headers['authorization'];
      await getCurrentUser();
      SharedPreferences.getInstance().then((pref) {
        final authData = json.encode(
          {
            'token': _token,
          },
        );
        pref.setString('authData', authData);
        notifyListeners();
      });
    }
    return response.statusCode;
  }

  Future<bool> autoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('authData')) {
      return false;
    }
    final authData = json.decode(pref.getString('authData'));
    _token = authData['token'];
    await getCurrentUser();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
  }

  Future<void> getCurrentUser() async {
    if (_user != null) {
      return;
    }
    final url = Uri.https(_baseUrl, '/account');
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: _token,
    };
    final response = await http.get(url, headers: headers);
    final userMap = json.decode(response.body);
    _user = User(
        username: userMap['username'],
        description: userMap['description'],
        first_name: userMap['first_name'],
        followers: userMap['followers'],
        following: userMap['following'],
        job_title: userMap['job_title'],
        last_name: userMap['last_name'],
        profile_photo_url: userMap['profile_photo_url']);
    notifyListeners();
  }

  Future<void> changeUserProfile(Map<String, dynamic> newUserInfo,
      [String profilePicture]) async {
    final url = Uri.https(_baseUrl, '/account');
    final body = jsonEncode({'account': newUserInfo});
    try {
      if (profilePicture != null) {
        changeProfilePicture(profilePicture);
      }
      final response = await http.patch(
        url,
        body: body,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: _token
        },
      );
      if (response.statusCode >= 400) {
        throw HttpException('Unable to change user information');
      }
    } catch (error) {
      rethrow;
    }
    getCurrentUser();
    notifyListeners();
  }

  void changeProfilePicture(String profilePicture) {
    html.window.addEventListener('message', (event) {
      html.MessageEvent event2 = event;
      final url = Uri.https(_baseUrl, '/account');
      final body = {
        'account': {
          'profile_photo': json.decode(event2.data),
        }
      };
      print(body);
      try {
        http.patch(
          url,
          body: json.encode(body),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            HttpHeaders.authorizationHeader: _token
          },
        ).then((response) {
          if (response.statusCode >= 400) {
            throw HttpException(json.decode(response.body)['error']);
          }
        });
      } catch (error) {
        rethrow;
      }
      getCurrentUser();
      notifyListeners();
    });
    js.context.callMethod('uploadFile', [profilePicture, 'profilePicture']);
  }
}
