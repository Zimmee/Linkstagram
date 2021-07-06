import 'package:flutter/material.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/models/user.dart';
import 'package:linkstagram/providers/authProvider/auth.dart';
import 'package:linkstagram/screens/editProfileScreen.dart';
import 'package:linkstagram/widgets/customAppbar/customAppBar.dart';
import 'package:linkstagram/widgets/editUserProfilePopUp.dart';
import 'package:linkstagram/widgets/newprofilePicture.dart';
import 'package:linkstagram/widgets/profilePicture.dart';
import 'package:linkstagram/widgets/profileScreenWidgets/photoGrid.dart';
import 'package:linkstagram/widgets/profileScreenWidgets/profileScreenButtons.dart';
import 'package:linkstagram/widgets/profileScreenWidgets/userInformation.dart';
import 'package:linkstagram/widgets/customAppbar/appBarDesktopButtons.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const routName = '/profilepage';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<Auth>(context, listen: false).user;
    if (_user == null) {
      return Container();
    }
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: CustomAppBar(
          preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.width > 560 ? 88 : 64),
          actions: [
            constraints.maxWidth > 1024
                ? AppBarDesktopButtons()
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Home'),
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            BorderSide(color: AppColors.GRAY, width: 0.5),
                          ),
                          foregroundColor:
                              MaterialStateProperty.all(AppColors.GRAY)),
                    ),
                  ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  constraints.maxWidth > 1024
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 1076,
                          ),
                          child: buildBuildProfilePageForWeb(_user))
                      : Column(
                          children: [
                            UserInformation(_user),
                            SizedBox(
                              height: 17,
                            ),
                            ProfileScreenButtons(() => Navigator.pushNamed(
                                context, EditProfileScreen.routName)),
                            SizedBox(
                              height: 40,
                            ),
                            PhotoGrid(),
                          ],
                        ),
                ]),
          ),
        ),
      ),
    );
  }

  Column buildBuildProfilePageForWeb(User _user) {
    return Column(
      children: [
        buildUserInformationForWeb(context, _user),
        SizedBox(
          height: 40,
        ),
        PhotoGrid(),
      ],
    );
  }
}

Container buildUserInformationForWeb(BuildContext context, User user) {
  return Container(
    height: 116,
    child: Row(
      children: [
        NewProfilePicture(
          url: user.profile_photo_url,
          size: 116,
          radius: 31.64,
          hasUnViewedStories: false,
        ),
        SizedBox(
          width: 32,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 6,
            ),
            Text(
              "${user.first_name} ${user.last_name}",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  height: 20 / 24),
            ),
            SizedBox(
              height: 10,
            ),
            Text(user.job_title,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 20 / 12)),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 304,
              child: Text(
                user.description,
                textAlign: TextAlign.start,
                style: TextStyle(
                    height: 20 / 12,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(1, 1, 1, 0.25),
                    fontSize: 12),
              ),
            ),
          ],
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(user.followers.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            height: 1)),
                    Text(
                      'Folowers',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(1, 1, 1, 0.25),
                          fontSize: 16,
                          height: 20 / 16),
                    ),
                  ],
                ),
                SizedBox(
                  width: 83,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(user.following.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            height: 1)),
                    Text(
                      'Following',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(1, 1, 1, 0.25),
                          fontSize: 16,
                          height: 20 / 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Container(
                width: 300,
                height: 40,
                child: ProfileScreenButtons(() => {
                      showDialog(
                          context: context,
                          builder: (context) => EditUserProfilePopUp())
                    })),
          ],
        ),
      ],
    ),
  );
}
