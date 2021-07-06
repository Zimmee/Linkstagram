import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/providers/posts.dart';
import 'package:provider/provider.dart';

class AddPostPopUp extends StatefulWidget {
  @override
  _AddPostPopUpState createState() => _AddPostPopUpState();
}

class _AddPostPopUpState extends State<AddPostPopUp> {
  String _image;
  String path;
  final _descriptionController = TextEditingController();

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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          padding: EdgeInsets.all(24),
          height: 683,
          width: 576,
          child: Column(
            children: [
              Expanded(child: buildImagePicker()),
              SizedBox(
                height: 32,
              ),
              buildDescriptionField(),
              SizedBox(
                height: 32,
              ),
              buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Container buildButtons(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 17),
      height: 40,
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
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
            height: 40,
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
                  Provider.of<Posts>(context, listen: false)
                      .createPost(_descriptionController.text, _image);
                  Navigator.of(context).pop();
                },
                child: Text('Post')),
          ),
        ),
      ]),
    );
  }

  Column buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(1, 1, 1, 0.25),
              fontSize: 12),
        ),
        Container(
          child: TextField(
              maxLines: 4,
              controller: _descriptionController,
              decoration: InputDecoration(hintText: "Description")),
        ),
      ],
    );
  }

  Container buildImagePicker() {
    return Container(
      child: GestureDetector(
        onTap: getImage,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: AppColors.GRAY),
          child: _image == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/addPost.png'),
                    Text(
                      'Upload any photos from your library',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(_image.split(',').last),
                    fit: BoxFit.fill,
                  )),
        ),
      ),
    );
  }
}
