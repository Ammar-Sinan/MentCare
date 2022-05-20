import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentcare/screens/card_auth.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  static const String routeName = 'AddCard';

  @override
  State createState() {
    return AddCardState();
  }
}

class AddCardState extends State<AddCard> {
  final _formKey = GlobalKey<FormState>();

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
        foregroundColor: Colors.black,
        title: const Text('Add Card'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 20.w, horizontal: 15.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          child: Text(
                            'Card Number',
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10.h),
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Align(
                                    child: FittedBox(
                                      child: Text(
                                        'Expiration Date',
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.all(10),
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Align(
                                    child: Text(
                                      'CCV',
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      contentPadding: EdgeInsets.all(10.h),
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        const Align(
                          child: Text(
                            'Country',
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10.h),
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: 100.h,
                ),
                SizedBox(
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, CardAuth.routeName),
                    child: const Text('Add Card'),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white)),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
