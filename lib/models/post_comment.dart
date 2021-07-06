import 'package:linkstagram/models/user.dart';

class PostComment {
  int id;
  User commenter;
  DateTime created_at;
  String message;

  PostComment({this.commenter, this.created_at, this.id, this.message});
}
