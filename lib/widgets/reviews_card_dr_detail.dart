import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard(
      {Key? key, required this.title, required this.number, required this.id})
      : super(key: key);

  final String title;
  final String number;
  final int id;

  // id is to target the GestureDetector specified for Review to Navigate to reviews page

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12.h,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(
          number,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
