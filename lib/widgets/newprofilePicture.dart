import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/widgets/errorImagePlaceholder.dart';
import 'package:linkstagram/widgets/loadingPlaceholder.dart';

class NewProfilePicture extends StatefulWidget {
  final String url;
  final double size;
  final double radius;
  bool hasUnViewedStories = false;
  NewProfilePicture({
    this.url,
    this.size,
    this.hasUnViewedStories,
    this.radius,
  });

  @override
  _NewProfilePictureState createState() => _NewProfilePictureState();
}

class _NewProfilePictureState extends State<NewProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return widget.hasUnViewedStories
        ? buildPictureWithStories()
        : buildPicture();
  }

  GestureDetector buildPictureWithStories() {
    return GestureDetector(
        onTap: () {
          setState(() {
            widget.hasUnViewedStories = false;
          });
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xFF74EDF2), Color(0xff5156E6)])),
          padding: EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius - 2),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(2),
            child: buildPicture(),
          ),
        ));
  }

  Container noProfilePicture() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(widget.radius - 4),
          border: Border.all(color: AppColors.GRAY, width: 0.5),
          image: DecorationImage(
              image: AssetImage('assets/images/noprofilepicture.png'),
              fit: BoxFit.fill)),
    );
  }

  Widget buildPicture() {
    return widget.url != null
        ? Container(
            child: CachedNetworkImage(
              imageUrl: widget.url,
              imageBuilder: (context, imageProvider) => Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(widget.radius - 4),
                  border: Border.all(color: AppColors.GRAY, width: 0.5),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.fill),
                ),
              ),
              placeholder: (context, url) => LoadingAnimationFade(
                BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(widget.radius - 4),
                  border: Border.all(color: AppColors.GRAY, width: 0.5),
                ),
                widget.size,
              ),
              errorWidget: (context, url, error) => ErrorPlaceholder(
                BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(widget.radius - 4),
                  border: Border.all(color: AppColors.GRAY, width: 0.5),
                ),
                widget.size,
              ),
            ),
          )
        : noProfilePicture();
  }
}
