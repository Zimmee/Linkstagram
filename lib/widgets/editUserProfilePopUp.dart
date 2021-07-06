import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/models/user.dart';
import 'package:linkstagram/providers/authProvider/auth.dart';
import 'package:linkstagram/providers/posts.dart';
import 'package:linkstagram/widgets/errorImagePlaceholder.dart';
import 'package:linkstagram/widgets/loadingPlaceholder.dart';
import 'package:provider/provider.dart';

class EditUserProfilePopUp extends StatefulWidget {
  @override
  _EditUserProfilePopUpState createState() => _EditUserProfilePopUpState();
}

class _EditUserProfilePopUpState extends State<EditUserProfilePopUp> {
  String _image;
  String path;
  final _descriptionController = TextEditingController();
  var _newUserData = {
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
          .changeUserProfile(_newUserData, _image);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile information changed succesfully")));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future getImage() async {
    final pickedFile =
        await Provider.of<Posts>(context, listen: false).getFile();
    if (pickedFile != null) {
      _image = pickedFile;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Unable to load image")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<Auth>(context, listen: false).user;
    if (_user == null) {
      return Container();
    }
    final node = FocusScope.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: LayoutBuilder(builder: (context, constraints) {
        print(constraints);
        return Form(
          key: _form,
          child: Container(
            padding: EdgeInsets.only(top: 48, left: 48, right: 48),
            width: 576, //MediaQuery.of(context).size.height * 0.5,
            height: 672,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Profile information",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff000000),
                        fontSize: 36,
                        height: 54 / 36,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.popUntil(
                              context, (Route<dynamic> route) => route.isFirst);
                          Provider.of<Auth>(context, listen: false).logout();
                        },
                        child: Text(
                          "Log out",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.RED,
                            fontSize: 16,
                            height: 20 / 16,
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    _buildProfileImagePicker(_user),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldCaption(
                            'First Name',
                          ),
                          Container(
                            height: 40,
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.BLACK,
                                fontSize: 16,
                                height: 20 / 16,
                              ),
                              initialValue: _user.first_name,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              onSaved: (val) =>
                                  _newUserData["first_name"] = val,
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          TextFieldCaption(
                            'Second Name',
                          ),
                          Container(
                            height: 40,
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.BLACK,
                                fontSize: 16,
                                height: 20 / 16,
                              ),
                              initialValue: _user.last_name,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              onSaved: (val) => _newUserData["last_name"] = val,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                TextFieldCaption(
                  'Job Title',
                ),
                Container(
                  height: 48,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.BLACK,
                      fontSize: 16,
                      height: 20 / 16,
                    ),
                    initialValue: _user.job_title,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    onSaved: (val) => _newUserData["job_title"] = val,
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                TextFieldCaption(
                  'Description',
                ),
                Container(
                  height: 68,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.BLACK,
                      fontSize: 16,
                      height: 20 / 16,
                    ),
                    minLines: 2,
                    maxLines: 2,
                    initialValue: _user.description,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    onSaved: (val) => _newUserData["description"] = val,
                  ),
                ),
                Spacer(),
                _buildButtons(context),
                Spacer(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Container _buildButtons(BuildContext context) {
    return Container(
      height: 48,
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide(
                    color: AppColors.GRAY,
                    width: 1,
                  )),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 48,
            child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(AppColors.BLUE),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  _saveForm();
                },
                child: Text('Save')),
          ),
        ),
      ]),
    );
  }

  Container _buildProfileImagePicker(User _user) {
    return Container(
      height: 148,
      width: 148,
      child: GestureDetector(
        onTap: getImage,
        child: Stack(children: [
          _user.profile_photo_url != null && _image == null
              ? Container(
                  height: 148,
                  width: 148,
                  child: CachedNetworkImage(
                    imageUrl: _user.profile_photo_url,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 148,
                      height: 148,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.GRAY, width: 0.5),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                    placeholder: (context, url) =>
                        LoadingAnimationFade(BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.GRAY, width: 0.5),
                    )),
                    errorWidget: (context, url, error) => ErrorPlaceholder(),
                  ),
                )
              : _image == null
                  ? Container(
                      height: 148,
                      width: 148,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.GRAY, width: 0.5),
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/noprofilepicture.png'),
                              fit: BoxFit.fill)),
                    )
                  : Container(
                      height: 148,
                      width: 148,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.GRAY, width: 0.5),
                        image: DecorationImage(
                            image: MemoryImage(
                              base64Decode(_image.split(',').last),
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 148,
              alignment: Alignment.center,
              height: 28,
              decoration: BoxDecoration(
                color: Color.fromRGBO(1, 1, 1, 0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                "Choose new photo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class TextFieldCaption extends StatelessWidget {
  final String _caption;

  TextFieldCaption(this._caption);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _caption,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.DARK_GRAY,
            fontSize: 12,
            height: 20 / 12,
          ),
        ),
        SizedBox(
          height: 2,
        ),
      ],
    );
  }
}
