import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/providers/authProvider/auth.dart';
import 'package:linkstagram/providers/post.dart';
import 'package:linkstagram/widgets/errorImagePlaceholder.dart';
import 'package:linkstagram/widgets/loadingPlaceholder.dart';
import 'package:linkstagram/widgets/newprofilePicture.dart';
import 'package:linkstagram/widgets/profilePicture.dart';
import 'package:linkstagram/widgets/viewPostPopUp.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class PostTile extends StatefulWidget {
  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final post = Provider.of<Post>(context, listen: false);
    final token = Provider.of<Auth>(context, listen: false).token;
    var author = post.author;
    return Container(
      padding: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 24.h),
      child: Column(
        children: [
          Container(
              height: 40.h,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: NewProfilePicture(
                  url: author.profile_photo_url,
                  size: 40,
                  radius: 12,
                  hasUnViewedStories: false,
                ),
                title: Text(
                  "${author.first_name} ${author.last_name}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  DateFormat.MMMMd().format(post.createdAt),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(1, 1, 1, 0.25),
                      fontSize: 12),
                ),
                trailing: Icon(Icons.more_vert_rounded),
              )),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () => MediaQuery.of(context).size.width > 1024
                ? showDialog(
                    context: context,
                    builder: (context) => ViewPostDialog(post),
                  )
                : null,
            child: Container(
              child: AspectRatio(
                aspectRatio: 1 / 0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: post.photos.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: post.photos[0].url,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => LoadingAnimationFade(),
                          errorWidget: (context, url, error) =>
                              ErrorPlaceholder(),
                        )
                      : Container(
                          color: Colors.grey,
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Container(
            width: double.infinity,
            child: post.description != ""
                ? ReadMoreText(
                    post.description,
                    style: TextStyle(fontSize: 16, color: AppColors.DARK_GRAY),
                    textAlign: TextAlign.start,
                    trimLines: 3,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: "...",
                    trimExpandedText: "",
                    delimiter: "",
                    moreStyle: TextStyle(fontSize: 16, color: Colors.black87),
                  )
                : Container(),
          ),
          SizedBox(
            height: 12.h,
          ),
          Container(
            child: Row(
              children: [
                Consumer<Post>(
                  builder: (context, value, child) => Row(children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
                        splashRadius: 20,
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () => value.toggleLike(token),
                        icon: Icon(
                          Icons.favorite,
                          color: post.isLiked ? AppColors.RED : AppColors.GRAY,
                        ),
                      ),
                    ),
                    Text(post.likesCount.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
                        splashRadius: 20,
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(
                          Icons.comment_rounded,
                          color: AppColors.GRAY,
                        ),
                        onPressed: () {
                          MediaQuery.of(context).size.width > 1024
                              ? showDialog(
                                  context: context,
                                  builder: (context) => ViewPostDialog(post),
                                )
                              : null;
                        },
                      ),
                    ),
                    FutureBuilder(
                      future: value.amountOfComments(),
                      builder: (context, snapshot) {
                        return Text(
                            snapshot.hasData ? snapshot.data.toString() : '0',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ));
                      },
                    ),
                  ]),
                ),
                Spacer(),
                TextButton(
                    onPressed: () {
                      print("share");
                    },
                    child: Row(
                      children: [
                        Text(
                          "Share",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.black)
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
