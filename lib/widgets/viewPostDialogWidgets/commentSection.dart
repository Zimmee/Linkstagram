import 'package:flutter/material.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/providers/post.dart';
import 'package:linkstagram/widgets/newprofilePicture.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentSection extends StatelessWidget {
  const CommentSection({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 32, right: 32),
        child: FutureBuilder(
          future: post.getComments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                        height: 16,
                      ),
                  itemCount: post.comments.length + 1,
                  itemBuilder: (context, index) {
                    if (index == post.comments.length) {
                      return Container();
                    } else
                      return Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 14),
                              child: NewProfilePicture(
                                url: post.comments[index].commenter
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 11),
                                    width: 288,
                                    child: Text(post.comments[index].message,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            height: 20 / 12)),
                                  ),
                                  Text(
                                      timeago.format(
                                          post.comments[index].created_at),
                                      style: TextStyle(
                                          color: AppColors.GRAY,
                                          fontWeight: FontWeight.w400,
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
    );
  }
}
