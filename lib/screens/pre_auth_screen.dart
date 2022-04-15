import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentcare/providers/login_prov.dart';
import 'package:mentcare/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class PreAuthScreen extends StatelessWidget {
  const PreAuthScreen({Key? key}) : super(key: key);

  static const routeName = "pre";


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
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: const Text('logo'),
          margin: EdgeInsets.only(top: 200.h),
        ),

        // SizedBox(height: 50.h,),
        Container(
            margin: EdgeInsets.only(bottom: 60.h, right: 15.w, left: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 50.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  child: ElevatedButton(
                    onPressed: () {
                      navigate(context, true);
                    },
                    child: const Text("Log in"),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      navigate(context, false);
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor))),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                )
              ],
            )),
      ],
    )));
  }

  void navigate(BuildContext b, bool bo) async {
    await b.read<LoginProv>().initIsLogIn(bo);
    Navigator.of(b).pushNamed(AuthScreen.routeName);
  }
}
