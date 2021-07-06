import 'package:flutter/material.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/widgets/addPostPopUp.dart';

class ProfileScreenButtons extends StatelessWidget {
  Function editProfileFunction;
  ProfileScreenButtons(this.editProfileFunction);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  shadowColor:
                      MaterialStateProperty.all(Color.fromRGBO(0, 0, 0, 0.5)),
                  elevation: MaterialStateProperty.all(1),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: editProfileFunction,
                child: Text('Edit profile')),
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
                  showDialog(
                      context: context, builder: (context) => AddPostPopUp());
                },
                child: Text('New Post')),
          ),
        ),
      ]),
    );
  }
}
