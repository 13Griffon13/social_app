abstract class RegularExpressions {
  static String get emailRegEx => r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  static String get nicknameRegEx => r'^[a-zA-Z_\-\.]{3,24}$';

  static String get passwordRegEx =>
      r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$';
}
