class UtilValidators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    // r'^(?=.*[0-9])(?=.*[!@#$%^&*])(.{6,})$',
    r'^.{4,10}$',
  );

  static final RegExp _codeRegExp = RegExp(
    r'^[0-9]$',
  );

  //Word of one or more chars with no special chars
  static final RegExp _wordRegExp = RegExp(r'^[a-zA-Z0-9-]+$');

  static final RegExp _phoneNumberRegExp =
      RegExp(r'^(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$');

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPhoneNumber(String phoneNumber) {
    return _phoneNumberRegExp.hasMatch(phoneNumber);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidName(String name) {
    return name.isNotEmpty && name.length <= 12;
  }

  static isValidWord(String word) {
    return _wordRegExp.hasMatch(word);
  }

  static isValiCode(String code) {
    return _codeRegExp.hasMatch(code);
  }

  ///Singleton factory
  static final UtilValidators _instance = UtilValidators._internal();

  factory UtilValidators() {
    return _instance;
  }

  UtilValidators._internal();
}
