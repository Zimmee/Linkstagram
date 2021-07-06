import 'package:flutter/material.dart';
import 'package:linkstagram/constants/app_colors.dart';

enum Language { EN, UA, PL, RU }

class ChooseLanguageButton extends StatefulWidget {
  @override
  _ChooseLanguageButtonState createState() => _ChooseLanguageButtonState();
}

class _ChooseLanguageButtonState extends State<ChooseLanguageButton> {
  bool _isOpenedChooseLanguageDropDown = false;
  Language _currentLanguage = Language.EN;
  OverlayEntry _chooseLanguageDropDown;
  GlobalKey actionKey;

  @override
  void initState() {
    actionKey = LabeledGlobalKey("Choose language");
    _chooseLanguageDropDown = chooseLanguageDropdown();
    super.initState();
  }

  @override
  void dispose() {
    if (_isOpenedChooseLanguageDropDown) {
      _chooseLanguageDropDown.remove();
      _chooseLanguageDropDown = null;
    }
    super.dispose();
  }

  double findXposition() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    return renderBox.localToGlobal(Offset.zero).dx;
  }

  @override
  Widget build(BuildContext context) {
    final overlay = Overlay.of(context);
    return TextButton(
        key: actionKey,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.black12),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(width: 0.5, color: AppColors.GRAY)),
          ),
          foregroundColor: MaterialStateProperty.all(Colors.black),
        ),
        onPressed: () {
          _isOpenedChooseLanguageDropDown = !_isOpenedChooseLanguageDropDown;
          if (_isOpenedChooseLanguageDropDown) {
            overlay.insert(_chooseLanguageDropDown);
          } else {
            _chooseLanguageDropDown.remove();
          }
        },
        child: Text(
          fromEnumToString(_currentLanguage),
          style: TextStyle(
            color: AppColors.BLACK,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ));
  }

  OverlayEntry chooseLanguageDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: findXposition() - 12, // 108,
        width: 64,
        top: 88,
        height: 132,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.WHITE,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 16,
                  color: Color.fromRGBO(0, 0, 0, 0.05))
            ],
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ...Language.values.map<Column>((language) {
                if (language != _currentLanguage) {
                  return buildLanguageButton(language);
                } else
                  return Column();
              }).toList(),
            ],
          ),
        ),
      );
    });
  }

  Column buildLanguageButton(Language language) {
    return Column(
      children: [
        Container(
          height: 20,
          child: TextButton(
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(AppColors.GRAY.withOpacity(0.3))),
            onPressed: () {
              setState(() {
                _currentLanguage = language;
                _chooseLanguageDropDown.remove();
                _isOpenedChooseLanguageDropDown = false;
              });
            },
            child: Text(
              fromEnumToString(language),
              style: TextStyle(
                color: AppColors.BLACK,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  String fromEnumToString(Language language) {
    switch (language) {
      case Language.EN:
        return "EN";
      case Language.UA:
        return "UA";
      case Language.PL:
        return "PL";
      case Language.RU:
        return "RU";
      default:
        return null;
    }
  }
}
