import 'package:flutter/material.dart';
import 'package:mentcare/screens/booking_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../providers/doctors_provider.dart';

class SessionsButtonsGrid extends StatefulWidget {
  // String drId;
  // SessionsButtonsGrid({required this.drId});

  @override
  State<SessionsButtonsGrid> createState() => _SessionsButtonsGridState();
}

class _SessionsButtonsGridState extends State<SessionsButtonsGrid> {
  final DateFormat formatter = DateFormat('dd/MM, hh:mm');

  @override
  void initState() {
    Provider.of<DoctorsDataProvider>(context, listen: false).fetchSessions();
    super.initState();
  }

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

    final sessionsDates =
        Provider.of<DoctorsDataProvider>(context, listen: false).sessions;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessionsDates.length,
      itemBuilder: (ctx, index) {
        return SizedBox(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(255, 224, 178, 0.75),
              shadowColor: const Color.fromRGBO(171, 130, 8, 0.20),
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(BookingScreen.routeName, arguments: [
                sessionsDates[index].dateAndTime,
                sessionsDates[index].id,
              ]);
            },
            child: FittedBox(
              fit: BoxFit.contain,

              /// Session Text
              child: Text(
                formatter.format(sessionsDates[index].dateAndTime),
                style: const TextStyle(
                  color: Color.fromRGBO(105, 65, 3, 1),
                ),
              ),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        mainAxisExtent: 56,
      ),
    );
  }
}
