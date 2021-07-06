import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linkstagram/constants/app_colors.dart';
import 'package:linkstagram/constants/form_validators.dart';
import 'package:linkstagram/providers/auth.dart';
import 'package:linkstagram/screens/authScreen.dart';
import 'package:provider/provider.dart';

class AuthFormWeb extends StatefulWidget {
  const AuthFormWeb({
    Key key,
  }) : super(key: key);

  @override
  _AuthFormWebState createState() => _AuthFormWebState();
}

class _AuthFormWebState extends State<AuthFormWeb> {
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

  Form buildAuthFormForWeb(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _mode == AuthMode.Login ? 'Log In' : 'Sign up',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 48,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height > 640 ? 48 : 15,
          ),
          Text(
            'Email',
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
          TextFormField(
            validator: FormValidator.emailValidator,
            decoration: InputDecoration(hintText: 'example@mail.com'),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_userNameFocusNode);
            },
            onSaved: (val) => _authData["login"] = val,
          ),
          SizedBox(
            height: 16,
          ),
          if (_mode == AuthMode.SignUp)
            Text(
              'User Name',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.DARK_GRAY,
                fontSize: 12,
              ),
            ),
          SizedBox(
            height: 2,
          ),
          if (_mode == AuthMode.SignUp)
            TextFormField(
              validator: FormValidator.userNameValidator,
              decoration: InputDecoration(hintText: "alexample..."),
              focusNode: _userNameFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              onSaved: (val) => _authData["username"] = val,
            ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Password',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.DARK_GRAY,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          TextFormField(
            validator: FormValidator.passwordValidator,
            focusNode: _passwordFocusNode,
            obscureText: true,
            decoration: InputDecoration(hintText: "Type in..."),
            onSaved: (val) => _authData["password"] = val,
          ),
          SizedBox(
            height: 32,
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
          SizedBox(
            height: 16,
          ),
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
                        _form.currentState.reset();
                      });
                    },
                    child: Text(_mode == AuthMode.Login ? 'Sign up' : 'Log In'))
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          constraints: BoxConstraints(maxHeight: 718, maxWidth: 592),
          child: Image.asset(_mode == AuthMode.SignUp
              ? "assets/images/signUp@1x.png"
              : "assets/images/logIn@1x.png")),
      SizedBox(
        width: 138,
      ),
      Container(
        width: 360,
        child: buildAuthFormForWeb(context),
      ),
    ]);
  }
}
