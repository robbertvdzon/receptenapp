import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  User? _user = null;

  User? getUser() {
    return _user;
  }

  void setUser(User? user) {
    _user = user;
  }
}
