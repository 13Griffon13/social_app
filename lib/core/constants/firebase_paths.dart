abstract class FirebasePaths{
  static String get userDataCollection => 'users_data';

  static String userAvatarFolder(String uid) => '/users/$uid/avatar';
}