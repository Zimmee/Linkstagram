import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/providers/auth.dart';
import 'package:provider/provider.dart';

class ChangeUserInfoForm extends StatefulWidget {
  @override
  _ChangeUserInfoFormState createState() => _ChangeUserInfoFormState();
}

class _ChangeUserInfoFormState extends State<ChangeUserInfoForm> {
  var _newUserData = {
    "username": "",
    //"profile_photo": null,
    "description": "",
    "first_name": "",
    "last_name": "",
    "job_title": "",
  };
  final _form = GlobalKey<FormState>();

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    try {
      await Provider.of<Auth>(context, listen: false)
          .changeUserProfile(_newUserData);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile information changed succesfully")));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<Auth>(context, listen: false).user;
    if (_user == null) {
      return Container();
    }
    final node = FocusScope.of(context);
    return Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 32,
            ),
            Text(
              'Nickname',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.DARK_GRAY,
                fontSize: 12.sp,
              ),
            ),
            TextFormField(
              initialValue: _user.username,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => node.nextFocus(),
              onSaved: (val) => _newUserData["username"] = val,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'First Name',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.DARK_GRAY,
                fontSize: 12.sp,
              ),
            ),
            TextFormField(
              initialValue: _user.first_name,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => node.nextFocus(),
              onSaved: (val) => _newUserData["first_name"] = val,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'Second Name',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.DARK_GRAY,
                fontSize: 12.sp,
              ),
            ),
            TextFormField(
              initialValue: _user.last_name,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => node.nextFocus(),
              onSaved: (val) => _newUserData["last_name"] = val,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'Job Title',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.DARK_GRAY,
                fontSize: 12.sp,
              ),
            ),
            TextFormField(
              initialValue: _user.job_title,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => node.nextFocus(),
              onSaved: (val) => _newUserData["job_title"] = val,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.DARK_GRAY,
                fontSize: 12.sp,
              ),
            ),
            TextFormField(
              initialValue: _user.description,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => node.nextFocus(),
              onSaved: (val) => _newUserData["description"] = val,
            ),
            SizedBox(
              height: 62,
            ),
            Container(
              width: double.infinity,
              height: 48,
              margin: EdgeInsets.only(bottom: 8.h),
              child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.BLUE),
                  ),
                  onPressed: () {
                    _saveForm();
                  },
                  child: Text(
                    "Save",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              width: double.infinity,
              height: 48,
              margin: EdgeInsets.only(bottom: 32.h),
              child: OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.GRAY, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancle",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
