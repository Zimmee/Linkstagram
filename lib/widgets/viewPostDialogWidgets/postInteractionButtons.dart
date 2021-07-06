import 'package:flutter/material.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/providers/auth.dart';
import 'package:linkstagram/providers/post.dart';
import 'package:linkstagram/providers/posts.dart';
import 'package:provider/provider.dart';

class PostInteractionButtons extends StatefulWidget {
  const PostInteractionButtons({
    Key key,
    @required this.post,
    @required this.token,
  }) : super(key: key);

  final Post post;
  final String token;

  @override
  _PostInteractionButtonsState createState() => _PostInteractionButtonsState();
}

class _PostInteractionButtonsState extends State<PostInteractionButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.GRAY, width: 0.5))),
      padding: EdgeInsets.symmetric(horizontal: 33),
      height: 64,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLikeButton(),
          Spacer(),
          if (Provider.of<Auth>(context).user.username ==
              widget.post.author.username)
            _buildDeletePostButton(context),
        ],
      ),
    );
  }

  TextButton _buildDeletePostButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        try {
          Provider.of<Posts>(context, listen: false).deletePost(widget.post.id);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Succesfully deleted post")));
        } catch (error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.toString())));
        }
      },
      child: Text(
        "Delete post",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.RED,
          fontSize: 12,
          height: 20 / 12,
        ),
      ),
    );
  }

  Row _buildLikeButton() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            splashRadius: 20,
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              widget.post.toggleLike(widget.token);
              setState(() {});
            },
            icon: Icon(
              Icons.favorite,
              color: widget.post.isLiked ? AppColors.RED : AppColors.GRAY,
            ),
          ),
        ),
        Text(widget.post.likesCount.toString(),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16)),
      ],
    );
  }
}
