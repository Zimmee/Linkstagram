import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linkstagram/models/user.dart';
import 'package:linkstagram/widgets/errorImagePlaceholder.dart';
import 'package:linkstagram/widgets/loadingPlaceholder.dart';
import 'package:linkstagram/widgets/profilePicture.dart';

class StoriesItem extends StatefulWidget {
  User _user;
  double size;

  StoriesItem(this._user, this.size);

  @override
  _StoriesItemState createState() => _StoriesItemState();
}

class _StoriesItemState extends State<StoriesItem> {
  bool isViewed = false;
  String url;
  @override
  Widget build(BuildContext context) {
    url = widget._user.profile_photo_url;
    return GestureDetector(
      onTap: () {
        setState(() {
          isViewed = true;
        });
      },
      child: isViewed
          ? ProfilePicture(
              height: widget.size,
              width: widget.size,
              url: url,
            )
          : newStories(url),
    );
  }

  Widget newStories(String url) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF74EDF2), Color(0xff5156E6)])),
      padding: EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(2),
        child: url != null
            ? CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            spreadRadius: 0,
                            blurRadius: 1,
                            offset: Offset(0, 0),
                          ),
                        ],
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                placeholder: (context, url) => LoadingAnimationFade(),
                errorWidget: (context, url, error) => ErrorPlaceholder(
                      BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            spreadRadius: 0,
                            blurRadius: 1,
                            offset: Offset(0, 0),
                          ),
                        ],
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ))
            : Container(
                height: widget.size,
                width: widget.size,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ],
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: AssetImage('assets/images/noprofilepicture.png'),
                      fit: BoxFit.fill),
                ),
              ),
      ),
    );
  }
}
