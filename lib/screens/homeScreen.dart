import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkstagram/providers/authProvider/auth.dart';
import 'package:linkstagram/providers/posts.dart';
import 'package:linkstagram/screens/profileScreen.dart';
import 'package:linkstagram/widgets/chooseLanguageButton.dart';
import 'package:linkstagram/widgets/customAppbar/customAppBar.dart';
import 'package:linkstagram/widgets/customAppbar/appBarDesktopButtons.dart';

import 'package:linkstagram/widgets/editUserProfilePopUp.dart';
import 'package:linkstagram/widgets/newprofilePicture.dart';
import 'package:linkstagram/widgets/postTile.dart';
import 'package:linkstagram/widgets/profileScreenWidgets/profileScreenButtons.dart';
import 'package:linkstagram/widgets/profileScreenWidgets/userInformation.dart';
import 'package:linkstagram/widgets/storiesView.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routName = '/homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Posts>(context, listen: false).getAllPosts();
    }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Auth>(context).getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LayoutBuilder(
              builder: (context, constraints) => Scaffold(
                appBar: CustomAppBar(
                  preferredSize:
                      Size.fromHeight(constraints.maxWidth > 560 ? 88 : 64),
                  actions: [
                    constraints.maxWidth > 1024
                        ? AppBarDesktopButtons()
                        : Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 12),
                                child: GestureDetector(
                                  child: CircleAvatar(
                                    child: NewProfilePicture(
                                      hasUnViewedStories: false,
                                      size: 40,
                                      url: Provider.of<Auth>(context,
                                              listen: false)
                                          .user
                                          .profile_photo_url,
                                      radius: 12,
                                    ),
                                  ),
                                  onTap: () => Navigator.pushNamed(
                                      context, ProfilePage.routName),
                                ),
                              ),
                            ],
                          )
                  ],
                ),
                body: isLoading
                    ? Container()
                    : constraints.maxWidth > 1024
                        ? buildForWeb(context)
                        : constraints.maxWidth > 560
                            ? Row(
                                children: [
                                  Spacer(),
                                  Feed(width: 560, isLoading: isLoading),
                                  Spacer(),
                                ],
                              )
                            : Feed(
                                width: double.infinity, isLoading: isLoading),
              ),
            );
          } else
            return Container();
        });
  }

  Row buildForWeb(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Feed(
            isLoading: isLoading,
            width: 560 //MediaQuery.of(context).size.width * 0.3,
            ),
        Container(
            width: MediaQuery.of(context).size.width * 0.27,
            child: Column(
              children: [
                SizedBox(
                  height: 24,
                ),
                UserInformation(Provider.of<Auth>(context).user),
                SizedBox(
                  height: 17,
                ),
                Container(
                  width: 220,
                  child: ProfileScreenButtons(
                    () => showDialog(
                      context: context,
                      builder: (context) => EditUserProfilePopUp(),
                    ),
                  ),
                ),
              ],
            )),
        Spacer(),
      ],
    );
  }
}

class Feed extends StatelessWidget {
  const Feed({
    @required this.width,
    @required this.isLoading,
  });
  final width;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<Posts>(context, listen: true);
    return Container(
      width: width,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              cacheExtent: 800,
              addAutomaticKeepAlives: true,
              itemCount: posts.posts.length + 2,
              itemBuilder: (context, i) => i == 0
                  ? SizedBox(
                      height:
                          MediaQuery.of(context).size.width > 1024 ? 48 : 24,
                    )
                  : i == 1
                      ? Strories()
                      : ChangeNotifierProvider.value(
                          value: posts.posts[i - 1],
                          child: PostTile(),
                        )),
    );
  }
}
