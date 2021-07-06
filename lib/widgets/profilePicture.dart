import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/widgets/errorImagePlaceholder.dart';
import 'package:linkstagram/widgets/loadingPlaceholder.dart';

class ProfilePicture extends StatelessWidget {
  final String url;
  final double height;
  final double width;

  ProfilePicture({this.height, this.url, this.width});

  @override
  Widget build(BuildContext context) {
    return url != null
        ? Container(
            height: height,
            width: width,
            child: CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.GRAY, width: 0.5),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.fill),
                ),
              ),
              placeholder: (context, url) => LoadingAnimationFade(BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.GRAY, width: 0.5),
              )),
              errorWidget: (context, url, error) => ErrorPlaceholder(),
            ),
          )
        : Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.GRAY, width: 0.5),
                image: DecorationImage(
                    image: AssetImage('assets/images/noprofilepicture.png'),
                    fit: BoxFit.fill)),
          );
  }
}
