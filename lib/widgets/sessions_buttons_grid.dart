import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../providers/doctors_provider.dart';

import '../screens/booking_screen.dart';

class SessionsButtonsGrid extends StatefulWidget {
  String? drId;
  SessionsButtonsGrid({this.drId});

  @override
  State<SessionsButtonsGrid> createState() => _SessionsButtonsGridState();
}

class _SessionsButtonsGridState extends State<SessionsButtonsGrid> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy, hh:mm');

  @override
  void initState() {
   fetch();
    super.initState();
  }

  /// Send the session data you get from here to the Booking.dart screen
  /// And use it there in the form to save the session
  void fetch () async
  {
    await Provider.of<DoctorsDataProvider>(context, listen: false).fetchSessions();
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

    final sessionsDates = Provider.of<DoctorsDataProvider>(context).sessions;
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
                sessionsDates[index].location,
              ]);
            },
            child: FittedBox(
              fit: BoxFit.contain,
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
