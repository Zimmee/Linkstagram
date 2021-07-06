import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkstagram/providers/users.dart';
import 'package:linkstagram/widgets/newprofilePicture.dart';
import 'package:provider/provider.dart';

class Strories extends StatefulWidget {
  @override
  _StroriesState createState() => _StroriesState();
}

class _StroriesState extends State<Strories>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    super.build(context);
    return FutureBuilder(
        future: Provider.of<Users>(context, listen: false).getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LayoutBuilder(
              builder: (context, constraints) => Container(
                padding: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 24),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.05)],
                      stops: [0.7, 1],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds);
                  },
                  child: Consumer<Users>(
                    builder: (context, users, _) => Container(
                      height: mediaQuery.size.width > 560 ? 64 : 40,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          width: 16,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: users.users.length,
                        itemBuilder: (context, index) => NewProfilePicture(
                          url: users.users[index].profile_photo_url,
                          size: mediaQuery.size.width > 560 ? 64 : 40,
                          hasUnViewedStories: true,
                          radius: mediaQuery.size.width > 560 ? 16 : 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else
            return Container();
        });
  }

  @override
  bool get wantKeepAlive => true;
}
