import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentcare/providers/user_provider.dart';
import 'package:mentcare/screens/doctor_dashboard.dart';
import 'package:mentcare/screens/loading.dart';
import 'package:mentcare/screens/tabs_screen.dart';
import 'package:mentcare/widgets/auth_form.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const String routeName = "AuthScreen";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;

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

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (con, snapshot) {
          if (snapshot.hasData) {
            return Loading();
          } else {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 30.h, top: 25.h),
                        child: const CircleAvatar(
                          child: Icon(Icons.local_hospital),
                        ),
                      ),
                      AuthForm(_authenticate, isLoading),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _authenticate(
      String fullName, String email, String password, bool isLogin) async {
    setState(() {
      isLoading = true;
    });

    UserCredential authResult;
    final _auth = FirebaseAuth.instance;
    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        CollectionReference collectionReference =
            FirebaseFirestore.instance.collection("users");
        collectionReference
            .doc(authResult.user!.uid)
            .set({'fullName': fullName, 'email': email, 'phoneNumber': ''});
      }
    } on FirebaseAuthException catch (msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.message.toString()),
          action: SnackBarAction(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            label: 'OK',
            textColor: Colors.blue.shade300,
          )));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


}
