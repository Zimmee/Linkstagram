import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/providers/auth.dart';
import 'package:linkstagram/screens/authScreen.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _textFieldDecoration = InputDecoration(
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
  );

  final _form = GlobalKey<FormState>();

  final _userNameFocusNode = FocusNode();

  final _passwordFocusNode = FocusNode();

  var _authData = {
    "username": "",
    "login": "",
    "password": "",
  };

  AuthMode _mode = AuthMode.Login;

  @override
  void dispose() {
    _userNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_mode == AuthMode.Login) {
      await Provider.of<Auth>(context, listen: false)
          .login(_authData['login'], _authData['password']);
    } else {
      try {
        final statuscode = await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['login'], _authData['username'],
                _authData['password']);
        if (statuscode == 200) {
          setState(() {
            _mode = AuthMode.Login;
            _form.currentState.reset();
          });
        }
      } catch (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _mode == AuthMode.Login ? 'Log In' : 'Sign up',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 32.sp,
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          Text(
            'Email',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.DARK_GRAY,
              fontSize: 12.sp,
            ),
          ),
          TextFormField(
            decoration:
                _textFieldDecoration.copyWith(hintText: 'example@mail.com'),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_userNameFocusNode);
            },
            onSaved: (val) => _authData["login"] = val,
          ),
          SizedBox(
            height: 16.h,
          ),
          if (_mode == AuthMode.SignUp)
            Text(
              'User Name',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.DARK_GRAY,
                fontSize: 12.sp,
              ),
            ),
          if (_mode == AuthMode.SignUp)
            TextFormField(
              decoration:
                  _textFieldDecoration.copyWith(hintText: "alexample..."),
              focusNode: _userNameFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              onSaved: (val) => _authData["username"] = val,
            ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            'Password',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.DARK_GRAY,
              fontSize: 12.sp,
            ),
          ),
          TextFormField(
            focusNode: _passwordFocusNode,
            obscureText: true,
            decoration: _textFieldDecoration.copyWith(hintText: "Type in..."),
            onSaved: (val) => _authData["password"] = val,
          ),
          Spacer(),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_mode == AuthMode.Login
                    ? 'Dont have an account?'
                    : 'Have a account?'),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _mode == AuthMode.Login
                            ? _mode = AuthMode.SignUp
                            : _mode = AuthMode.Login;
                      });
                    },
                    child: Text(_mode == AuthMode.Login ? 'Sign up' : 'Log In'))
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 48,
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
                  _mode == AuthMode.Login ? 'Log In' : 'Sign up',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
