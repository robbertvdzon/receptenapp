import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  User? _user = null;

  User? getUser() {
    return _user;
  }

  String getUsersEmail() {
    return _user?.email??"none";
  }

  void setUser(User? user) {
    _user = user;
  }
}
