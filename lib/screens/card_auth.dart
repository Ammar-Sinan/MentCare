import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentcare/screens/add_payment_screen.dart';

class CardAuth extends StatelessWidget {
  const CardAuth({Key? key}) : super(key: key);

  static const String routeName = 'cardAuth';

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(width, height),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Verification'),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25.h, vertical: 70.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 20.w),
              height: 150.h,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50.h,
                  ),
                   Text(
                    'Card Added successfully',
                    style: TextStyle(fontSize: 20.sp),
                  )
                ],
              ),
            ),

             SizedBox(
              height: 40.h,
             ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, AddPaymentScreen.routeName),
                child: const Text('Verify Card'),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
