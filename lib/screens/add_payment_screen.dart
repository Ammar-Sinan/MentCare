import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentcare/screens/add_card_screen.dart';

class AddPaymentScreen extends StatelessWidget {
  const AddPaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width),
        designSize: const Size(360, 580),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return Scaffold(
        appBar: AppBar(
          title: Text('Add payment method'),
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
                  icon: Icon(Icons.credit_card),
                  label: Text('Add payment method'),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Colors.black))),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit),
                label: Text('Edit payment method'),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.black)),
              ),
            ],
          ),
        ));
  }
}
