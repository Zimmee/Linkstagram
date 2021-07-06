import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/providers/posts.dart';
import 'package:linkstagram/providers/users.dart';
import 'package:linkstagram/screens/authScreen.dart';
import 'package:linkstagram/screens/editProfileScreen.dart';
import 'package:linkstagram/screens/homeScreen.dart';
import 'package:linkstagram/screens/profileScreen.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Posts>(
            create: (_) => Posts(),
            update: (ctx, auth, previousPosts) =>
                previousPosts.update(auth.token, previousPosts.posts)),
        ChangeNotifierProxyProvider<Auth, Users>(
            create: (_) => Users(),
            update: (ctx, auth, previousData) =>
                previousData.update(auth.token, previousData)),
      ],
      child: ScreenUtilInit(
        builder: () => Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Linkstagram',
            theme: ThemeData(
              textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              )),
              accentColor: AppColors.BLUE,
              backgroundColor: AppColors.WHITE,
              inputDecorationTheme: InputDecorationTheme(
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.RED, width: 1.0),
                  borderRadius: new BorderRadius.circular(12),
                ),
                errorStyle: TextStyle(
                    fontSize: 10,
                    color: AppColors.RED,
                    fontWeight: FontWeight.w500),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.RED, width: 1.0),
                  borderRadius: new BorderRadius.circular(12),
                ),
                hintStyle: TextStyle(color: Color.fromRGBO(1, 1, 1, 0.25)),
                contentPadding: EdgeInsets.all(12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.GRAY, width: 1.0),
                  borderRadius: new BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff000000), width: 1.0),
                  borderRadius: new BorderRadius.circular(12),
                ),
              ),
              primarySwatch: Colors.blue,
              fontFamily: 'Poppins',
            ),
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? Scaffold(
                                body: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : snapshot.data == true
                                ? HomeScreen()
                                : AuthScreen()),
            routes: {
              HomeScreen.routName: (_) => HomeScreen(),
              ProfilePage.routName: (_) => ProfilePage(),
              EditProfileScreen.routName: (_) => EditProfileScreen(),
            },
          ),
        ),
        designSize: Size(289, 625),
      ),
    );
  }
}
