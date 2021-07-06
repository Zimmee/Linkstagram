import 'package:flutter/material.dart';
import 'package:linkstagram/widgets/authScreenWidgets/authFormWeb.dart';
import 'package:linkstagram/widgets/chooseLanguageButton.dart';
import 'package:linkstagram/widgets/customAppbar/customAppBar.dart';
import 'package:linkstagram/widgets/authScreenWidgets/authForm.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AuthMode { Login, SignUp }

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        preferredSize: Size.fromHeight(width > 1024 ? 88 : 64),
        actions: [
          if (width > 1024)
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(right: 64),
                  child: ChooseLanguageButton(),
                ),
              ],
            )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => constraints.maxWidth > 1024
            ? AuthFormWeb()
            : Container(
                margin: EdgeInsets.only(
                    left: 16.w, right: 16.w, top: 48.h, bottom: 32.h),
                child: AuthForm(),
              ),
      ),
    );
  }
}
