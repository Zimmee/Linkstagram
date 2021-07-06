import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/widgets/newprofilePicture.dart';

class UserInformation extends StatelessWidget {
  final _user;

  UserInformation(this._user);

  Widget addStoriesButton() {
    return GestureDetector(
      onTap: () => print("Add stories"),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xFF74EDF2), Color(0xff5156E6)])),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 2,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.WHITE,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Container(
              width: 10,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.WHITE,
                borderRadius: BorderRadius.circular(1),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(_user.followers.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    const Text(
                      'Folowers',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(1, 1, 1, 0.25),
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 94,
                child: Stack(alignment: Alignment.topCenter, children: [
                  NewProfilePicture(
                    size: 88,
                    radius: 24,
                    url: _user.profile_photo_url,
                    hasUnViewedStories: true,
                  ),
                  Positioned(top: 74, child: addStoriesButton()),
                ]),
              ),
              Container(
                child: Column(
                  children: [
                    Text(_user.following.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    const Text(
                      'Following',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(1, 1, 1, 0.25),
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 23,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${_user.first_name} ${_user.last_name}",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 4,
              height: 1,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(1, 1, 1, 0.5),
                  borderRadius: BorderRadius.circular(1)),
            ),
            Text(_user.job_title,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 17),
          width: 304,
          child: Text(
            _user.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
                height: 20 / 12,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(1, 1, 1, 0.25),
                fontSize: 12),
          ),
        ),
      ],
    );
  }
}
