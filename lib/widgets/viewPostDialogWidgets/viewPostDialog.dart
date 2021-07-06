import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/providers/auth.dart';
import 'package:linkstagram/providers/post.dart';
import 'package:linkstagram/widgets/newprofilePicture.dart';
import 'package:linkstagram/widgets/viewPostDialogWidgets/commentSection.dart';
import 'package:linkstagram/widgets/viewPostDialogWidgets/postImage.dart';
import 'package:linkstagram/widgets/viewPostDialogWidgets/postInteractionButtons.dart';
import 'package:provider/provider.dart';

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
    final post = widget.post;
    final token = Provider.of<Auth>(context, listen: false).token;
    return LayoutBuilder(
      builder: (context, constraints) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          height: 680,
          width: 1079,
          child: Row(
            children: [
              PostImage(post: post),
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
                              url: post.author.profile_photo_url,
                              size: 40,
                              hasUnViewedStories: false,
                              radius: 12,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                                "${post.author.first_name} ${post.author.last_name}",
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
                      CommentSection(
                        post: post,
                      ),
                      PostInteractionButtons(post: post, token: token),
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
                                    post.createComment(
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
