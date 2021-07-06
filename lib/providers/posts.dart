import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'dart:js' as js;

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:linkstagram/models/photo.dart';
import 'package:linkstagram/models/user.dart';
import 'package:linkstagram/providers/post.dart';

class Posts with ChangeNotifier {
  List<Post> _posts = [];
  String _token;
  List<Post> get posts {
    return [..._posts];
  }

  Posts() {
    _token = null;
  }

  Posts update(String token, List<Post> posts) {
    _token = token;
    _posts = posts;
    return this;
  }

  Future<void> getAllPosts() async {
    final url = Uri.https('linkstagram-api.ga', '/posts');
    var jsonPosts = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: _token
      },
    );
    var tmp = json.decode(jsonPosts.body);
    //print(tmp[0]['is_liked']);
    for (var item in tmp) {
      var author = User(
          username: item['author']['username'],
          description: item['author']['description'],
          first_name: item['author']['first_name'],
          followers: item['author']['followers'],
          following: item['author']['following'],
          job_title: item['author']['job_title'],
          last_name: item['author']['last_name'],
          profile_photo_url: item['author']['profile_photo_url']);
      var post = Post(
        author: author,
        createdAt: parseDate(item['created_at'].toString()),
        id: item['id'],
        isLiked: item['is_liked'],
        likesCount: item['likes_count'],
        description: item['description'],
        photos: (item['photos'] as List)
            .map((e) => Photo(id: e['id'], url: e['url']))
            .toList(),
      );
      //await post.getComments();
      _posts.add(post);
      //print(post.is_liked);
    }
    notifyListeners();
  }

  Future<List<Post>> getPostsForSingleUser(String username) async {
    List<Post> posts = [];
    final url = Uri.https('linkstagram-api.ga', '/profiles/$username/posts');
    var jsonPosts = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    );
    var tmp = json.decode(jsonPosts.body);
    for (var item in tmp) {
      var author = User(
          username: item['author']['username'],
          description: item['author']['description'],
          first_name: item['author']['first_name'],
          followers: item['author']['followers'],
          following: item['author']['following'],
          job_title: item['author']['job_title'],
          last_name: item['author']['last_name'],
          profile_photo_url: item['author']['profile_photo_url']);
      var post = Post(
        author: author,
        createdAt: parseDate(item['created_at'].toString()),
        id: item['id'],
        isLiked: item['is_liked'],
        likesCount: item['likes_count'],
        description: item['description'],
        photos: (item['photos'] as List)
            .map((e) => Photo(id: e['id'], url: e['url']))
            .toList(),
      );
      posts.add(post);
    }
    return [...posts];
  }

  void createPost(String description, String image) {
    final url = Uri.https('linkstagram-api.ga', '/posts');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: _token
    };
    html.window.addEventListener("message", (event) {
      html.MessageEvent event2 = event;
      Map body = {
        "post": {
          "description": description,
          "photos_attributes": [
            {"image": json.decode(event2.data)}
          ]
        }
      };
      print(body);
      http
          .post(url, body: json.encode(body), headers: headers)
          .then((response) {
        print(json.decode(response.body));
        if (response.statusCode < 400) {
          print(json.decode(response.body));
          getAllPosts().then((value) => notifyListeners());
        }
      });
    });
    js.context.callMethod('uploadFile', [image, "image"]);
  }

  Future<String> getFile() {
    final completer = new Completer<String>();
    final html.InputElement input = html.document.createElement(
      'input',
    );
    input
      ..type = 'file'
      ..accept = 'image/*';
    input.onChange.listen((e) async {
      final List<html.File> files = input.files;
      final reader = new html.FileReader();
      reader.readAsDataUrl(files[0]);
      reader.onError.listen((error) => completer.completeError(error));
      await reader.onLoad.first;
      completer.complete(reader.result as String);
    });
    input.click();
    return completer.future;
  }

  // void uploadFile() async {
  //   getFile().then(
  //       (value) => (js.context.callMethod('uploadFile', [value, "image"])));
  // }

  Future<void> deletePost(int id) async {
    final url = Uri.https('linkstagram-api.ga', '/posts/$id');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: _token
    };
    var response = await http.delete(url, headers: headers);
    if (response.statusCode < 400) {
      _posts.removeWhere((element) => element.id == id);
      notifyListeners();
    } else {
      throw HttpException("Unable to delete post");
    }
  }
}

DateTime parseDate(String date) {
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");

  return format.parse(date);
}

// Future<http.Response> getUploadUrl(String path) async {
//   final queryParameters = {
//     'filename': basename(path),
//     'type': MediaType('image', extension(path).substring(1)).mimeType,
//   };
//   final url = Uri.https('linkstagram-api.ga', '/s3/params', queryParameters);
//   var response = await http.get(url);
//   return response;
// }

// Future<Map<String, dynamic>> uploadImage(File file) async {
//   var uploadUrl = await getUploadUrl(file.path);
//   print(json.decode(uploadUrl.body));
//   var multipartFile = await http.MultipartFile.fromPath('file', file.path);
//   var postData = json.decode(uploadUrl.body);
//   var request =
//       http.MultipartRequest(postData['method'], Uri.parse(postData['url']));
//   request.files.add(multipartFile);
//   request.fields.addAll(Map<String, String>.from(postData['fields']));
//   var streamResponse = await request.send();
//   var response = await http.Response.fromStream(streamResponse);
//   if (response.statusCode < 400) {
//     return {
//       'id': (postData['fields']['key'] as String).split('/').last,
//       'storage': 'cache',
//       'metadata': {
//         'size': file.lengthSync(),
//         'filename': basename(file.path),
//         'mime_type':
//             MediaType('image', extension(file.path).substring(1)).mimeType
//       }
//     };
//   }
// }
