import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/providers/post.dart';
import 'package:linkstagram/widgets/imagePlaceholders/errorImagePlaceholder.dart';
import 'package:linkstagram/widgets/imagePlaceholders/loadingPlaceholder.dart';

class PostImage extends StatelessWidget {
  const PostImage({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
        ),
      ),
      height: double.infinity,
      width: 599,
      child: post.photos.isNotEmpty && post.photos[0].url != null
          ? CachedNetworkImage(
              imageUrl: post.photos[0].url,
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
              errorWidget: (context, url, error) => ErrorPlaceholder(),
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
    );
  }
}
