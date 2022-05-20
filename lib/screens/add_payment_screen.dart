import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentcare/screens/add_card_screen.dart';

class AddPaymentScreen extends StatelessWidget {
  const AddPaymentScreen({Key? key}) : super(key: key);

  static const String routeName = 'addPaymentScreen';

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
          title: const Text('Add payment method'),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 25.h, horizontal: 10.w),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed(AddCard.routeName),
                  icon: const Icon(Icons.credit_card),
                  label: const Text('Add payment method'),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Colors.black))),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Edit payment method'),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.black)),
              ),
            ],
          ),
        ));
  }
}
