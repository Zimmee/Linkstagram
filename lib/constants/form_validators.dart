import 'package:form_field_validator/form_field_validator.dart';

class FormValidator {
  static final passwordValidator = MultiValidator([
    RequiredValidator(errorText: "* Required"),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
    //     errorText: 'passwords must have at least one special character')
  ]);

  static final emailValidator = MultiValidator([
    RequiredValidator(errorText: "* Required"),
    EmailValidator(errorText: "Enter valid email id"),
  ]);
  static final userNameValidator = MultiValidator([
    RequiredValidator(errorText: "* Required"),
    MinLengthValidator(5,
        errorText: 'username must be at least 5 symbols long'),
  ]);
}
