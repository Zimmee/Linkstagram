import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/providers/authProvider/auth.dart';
import 'package:linkstagram/providers/post.dart';
import 'package:linkstagram/providers/posts.dart';
import 'package:linkstagram/widgets/errorImagePlaceholder.dart';
import 'package:linkstagram/widgets/loadingPlaceholder.dart';
import 'package:linkstagram/widgets/newprofilePicture.dart';
import 'package:linkstagram/widgets/profilePicture.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewPostDialog extends StatefulWidget {
  final Post post;

  ViewPostDialog(this.post);
  @override
  _ViewPostDialogState createState() => _ViewPostDialogState();
}

class _ViewPostDialogState extends State<ViewPostDialog> {
  TextEditingController _commentController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context, listen: false).token;
    return LayoutBuilder(
      builder: (context, constraints) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          height: 680,
          width: 1079,
          //constraints: BoxConstraints(maxHeight: 680, maxWidth: 1079),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0),
                  ),
                ),
                height: double.infinity,
                width: 599,
                child: widget.post.photos.isNotEmpty &&
                        widget.post.photos[0].url != null
                    ? CachedNetworkImage(
                        imageUrl: widget.post.photos[0].url,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              topLeft: Radius.circular(12.0),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => LoadingAnimationFade(),
                        errorWidget: (context, url, error) =>
                            ErrorPlaceholder(),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            topLeft: Radius.circular(12.0),
                          ),
                          color: AppColors.GRAY,
                        ),
                      ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.GRAY, width: 0.5))),
                        padding: EdgeInsets.symmetric(horizontal: 33),
                        height: 80,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NewProfilePicture(
                              url: widget.post.author.profile_photo_url,
                              size: 40,
                              hasUnViewedStories: false,
                              radius: 12,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                                "${widget.post.author.first_name} ${widget.post.author.last_name}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                            Spacer(),
                            Container(
                              child: IconButton(
                                splashRadius: 20,
                                iconSize: 25,
                                hoverColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                color: AppColors.DARK_GRAY,
                                onPressed: Navigator.of(context).pop,
                                icon: Icon(Icons.close),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 20, left: 32, right: 32),
                          child: FutureBuilder(
                            future: widget.post.getComments(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: 16,
                                        ),
                                    itemCount: widget.post.comments.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index ==
                                          widget.post.comments.length) {
                                        return Container();
                                      } else
                                        return Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 14),
                                                child: NewProfilePicture(
                                                  url: widget
                                                      .post
                                                      .comments[index]
                                                      .commenter
                                                      .profile_photo_url,
                                                  size: 40,
                                                  radius: 12,
                                                  hasUnViewedStories: false,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 11),
                                                      width: 288,
                                                      child: Text(
                                                          widget
                                                              .post
                                                              .comments[index]
                                                              .message,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 12,
                                                              height: 20 / 12)),
                                                    ),
                                                    Text(
                                                        timeago.format(widget
                                                            .post
                                                            .comments[index]
                                                            .created_at),
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.GRAY,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                    });
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ),
                      LikeButton(post: widget.post, token: token),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: AppColors.GRAY, width: 0.5))),
                        padding: EdgeInsets.symmetric(horizontal: 33),
                        height: 80,
                        child: Form(
                          key: _form,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: TextFormField(
                                validator: RequiredValidator(
                                    errorText: "Comment can't be empty"),
                                decoration: InputDecoration(
                                    errorStyle:
                                        TextStyle(fontSize: 9, height: 0.1),
                                    hintText: "Add a comment...",
                                    border: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: AppColors.DARK_GRAY,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    )),
                                controller: _commentController,
                              )),
                              TextButton(
                                  onPressed: () {
                                    final isValid =
                                        _form.currentState.validate();
                                    if (!isValid) {
                                      return;
                                    }
                                    widget.post.createComment(
                                        token, _commentController.text);
                                    _form.currentState.reset();
                                    setState(() {});
                                  },
                                  child: Text(
                                    "Post",
                                    style: TextStyle(
                                        color: AppColors.BLUE,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton({
    Key key,
    @required this.post,
    @required this.token,
  }) : super(key: key);

  final Post post;
  final String token;

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
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
          Spacer(),
          if (Provider.of<Auth>(context).user.username ==
              widget.post.author.username)
            TextButton(
              onPressed: () {
                try {
                  Provider.of<Posts>(context, listen: false)
                      .deletePost(widget.post.id);
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
            ),
        ],
      ),
    );
  }
}
