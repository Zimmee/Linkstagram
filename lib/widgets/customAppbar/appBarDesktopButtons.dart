import 'package:flutter/material.dart';
import 'package:linkstagram/providers/authProvider/auth.dart';
import 'package:linkstagram/screens/profileScreen.dart';
import 'package:linkstagram/widgets/chooseLanguageButton.dart';
import 'package:linkstagram/widgets/customAppbar/customAppBar.dart';
import 'package:linkstagram/widgets/newprofilePicture.dart';
import 'package:linkstagram/widgets/profilePicture.dart';
import 'package:provider/provider.dart';

class AppBarDesktopButtons extends StatefulWidget {
  const AppBarDesktopButtons({
    Key key,
  }) : super(key: key);

  @override
  _AppBarDesktopButtonsState createState() => _AppBarDesktopButtonsState();
}

class _AppBarDesktopButtonsState extends State<AppBarDesktopButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 85,
          child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.black),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () => Navigator.pushReplacementNamed(context, "/"),
              child: Text('Home')),
        ),
        SizedBox(
          width: 16,
        ),
        Container(
          height: 40,
          width: 40,
          child: ChooseLanguageButton(),
        ),
        SizedBox(
          width: 16,
        ),
        Container(
          padding: EdgeInsets.only(right: 64),
          child: GestureDetector(
            child: CircleAvatar(
              child: NewProfilePicture(
                size: 40,
                url: Provider.of<Auth>(context, listen: false)
                    .user
                    .profile_photo_url,
                hasUnViewedStories: false,
                radius: 12,
              ),
            ),
            onTap: () =>
                Navigator.pushReplacementNamed(context, ProfilePage.routName),
          ),
        ),
      ],
    );
  }
}
