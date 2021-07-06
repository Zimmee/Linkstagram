import 'package:flutter/material.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/providers/auth.dart';
import 'package:linkstagram/widgets/customAppbar/customAppBar.dart';
import 'package:linkstagram/widgets/editProfileScreenWidgets/changeUserInfoForm.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const routName = '/editProfile';
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        preferredSize: Size.fromHeight(64),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: OutlinedButton(
              onPressed: () {
                Navigator.popUntil(
                    context, (Route<dynamic> route) => route.isFirst);
                Provider.of<Auth>(context, listen: false).logout();
              },
              child: Text('Log out'),
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                  BorderSide(color: AppColors.RED, width: 0.5),
                ),
                foregroundColor: MaterialStateProperty.all(
                  AppColors.RED,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ChangeUserInfoForm(),
      ),
    );
  }
}
