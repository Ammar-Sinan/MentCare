import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/login_prov.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this._authenticate, this.isLoading, {Key? key})
      : super(key: key);
  final Function _authenticate;
  final bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  late bool isLogin;
  String fullName = '';
  String password = '';
  String email = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLogin = context.watch<LoginProv>().getIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    ScreenUtil.init(
        BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width),
        designSize: Size(width, height),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        children: [
          isLogin
              ? Text('Welcome Back', style: TextStyle(fontSize: 30.sp))
              : Text('Create Account', style: TextStyle(fontSize: 30.sp)),
          SizedBox(
            height: 8.h,
          ),
          isLogin
              ? Text('Log in',
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade600))
              : Text('Sign up',
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade600)),
          SizedBox(
            height: 8.h,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isLogin)
                  Align(
                    child: Text('Full name',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        )),
                    alignment: Alignment.bottomLeft,
                  ),
                if (!isLogin)
                  TextFormField(
                    key: const ValueKey('fullName'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.man_outlined,
                      ),
                      contentPadding: EdgeInsets.all(14.h),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your full name";
                      }
                      List spitted;
                      spitted = value.trim().split(' ');
                      if (spitted.length < 2) {
                        return 'please enter your full name';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    onSaved: (value) => fullName = value!.trim(),
                    textCapitalization: TextCapitalization.words,
                  ),
                SizedBox(
                  height: 14.h,
                ),
                Align(
                  child: Text('Email',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      )),
                  alignment: Alignment.centerLeft,
                ),
                TextFormField(
                  key: const ValueKey('email'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                      ),
                      contentPadding: EdgeInsets.all(14.h)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter an email";
                    }
                    if (!value.endsWith('.com') || !value.contains('@')) {
                      return 'please enter a valid email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => email = value!.trim(),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 14.h,
                ),
                Align(
                  child: Text('Password',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      )),
                  alignment: Alignment.topLeft,
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),
                      contentPadding: EdgeInsets.all(14.h)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter your password";
                    }
                    if (value.length < 8) {
                      return "too short!";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (value) => password = value!.trim(),
                  obscureText: true,
                ),
                Container(
                  height: 50.h,
                  margin: EdgeInsets.only(top: isLogin ? 50.h : 40.h),
                  child: widget.isLoading
                      ? const Align(
                          child: CircularProgressIndicator(),
                          alignment: Alignment.center,
                        )
                      : ElevatedButton(
                          onPressed: _submit,
                          child: isLogin
                              ? const Text("Log in")
                              : const Text('Sign up'),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25))),
                          ),
                        ),
                ),
                isLogin
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Not a member?',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                              onPressed: () => logInSignUpSwitch(context),
                              child: const Text('sign up'))
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already a member?',
                              style: TextStyle(color: Colors.grey)),
                          TextButton(
                              onPressed: () => logInSignUpSwitch(context),
                              child: const Text('log in'))
                        ],
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    bool valid = _formKey.currentState!.validate();

    if (!valid) {
      return;
    }

    _formKey.currentState!.save();
    widget._authenticate(fullName, email, password, isLogin);
  }

  void logInSignUpSwitch(BuildContext c) {
    setState(() {
      isLogin = !isLogin;
    });
  }
}
