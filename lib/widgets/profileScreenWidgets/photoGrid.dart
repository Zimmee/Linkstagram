import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linkstagram/providers/authProvider/auth.dart';
import 'package:linkstagram/providers/post.dart';
import 'package:linkstagram/providers/posts.dart';
import 'package:linkstagram/widgets/errorImagePlaceholder.dart';
import 'package:linkstagram/widgets/loadingPlaceholder.dart';
import 'package:linkstagram/widgets/viewPostPopUp.dart';
import 'package:provider/provider.dart';

class PhotoGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<Auth>(context, listen: false).user;
    return Container(
      child: FutureBuilder<List<Post>>(
        future: Provider.of<Posts>(context, listen: true)
            .getPostsForSingleUser(_user.username),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator());
          else {
            return GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data.map((Post imagePost) {
                  return GridTile(
                    child: GestureDetector(
                      onTap: () => MediaQuery.of(context).size.width > 1024
                          ? showDialog(
                              context: context,
                              builder: (context) => ViewPostDialog(imagePost),
                            )
                          : null,
                      child: CachedNetworkImage(
                        imageUrl: imagePost.photos[0].url,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => LoadingAnimationFade(),
                        errorWidget: (context, url, error) =>
                            ErrorPlaceholder(),
                      ),
                    ),
                  );
                }).toList());
          }
        },
      ),
    );
  }
}
