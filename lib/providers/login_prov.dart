import 'package:flutter/cupertino.dart';

class LoginProv with ChangeNotifier {
  bool isLogin = false;

  Future<void> initIsLogIn(bool value) async{
    isLogin = value;
  }

  bool getIsLogin() {
    return isLogin;
  }
}
