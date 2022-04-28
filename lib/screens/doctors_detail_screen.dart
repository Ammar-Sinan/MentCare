import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../widgets/reviews_card_dr_detail.dart';
import '../providers/doctors_provider.dart';

class DoctorDetails extends StatelessWidget {
  Color iconColor = Colors.white;

  static const routeName = '/doctor-detail';

  @override
  Widget build(BuildContext context) {
    final doctorId = ModalRoute.of(context)!.settings.arguments as String;
    final doctorData =
        Provider.of<DoctorsDataProvider>(context).findById(doctorId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(212, 229, 241, 1.0),
        elevation: 0,
      ),
      body: Stack(
        // alignment: Alignment.center,
        children: <Widget>[
          Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400.h,
                color: const Color.fromRGBO(212, 229, 241, 1.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 48.w,
                        ),
                        const CircleAvatar(
                          // profile picture
                          radius: 48,
                          backgroundColor: Color.fromRGBO(22, 92, 144, 1.0),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.5.h),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.message_rounded),
                            color: Theme.of(context).primaryColor,
                            iconSize: 28,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(doctorData.name,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w300)),
                    SizedBox(height: 16.h),
                    Text(
                      doctorData.category,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Buttons(
                            title: 'Booking',
                            icon: Icon(Icons.calendar_today_outlined,
                                color: iconColor),
                            route: '1'),
                        Buttons(
                            title: 'location',
                            icon: Icon(Icons.location_on_outlined,
                                color: iconColor),
                            route: '2'),
                        Buttons(
                            title: 'save',
                            icon:
                                Icon(Icons.archive_outlined, color: iconColor),
                            route: '3'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 350.h,
            left: 50.w,
            right: 50.w,
            child: SizedBox(
              height: 100.h,
              width: 256.w,
              child: Card(
                elevation: 8,
                shadowColor: const Color.fromRGBO(168, 162, 162, 0.15),
                //color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    ReviewCard(title: 'Patients', number: '54', id: 420),
                    ReviewCard(title: 'Reviews', number: '34', id: 420),
                    ReviewCard(title: 'Rating', number: '4.8', id: 420),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w, left: 16.w, bottom: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 480.h,
                ),
                const Text(
                  'Nearest available dates',
                  style: TextStyle(fontSize: 19.2, fontWeight: FontWeight.w400),
                ),
                // Call THe nearest available dates buttons here
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SessionsDateButton(dateAndTime: '29 Mar - 4:00 Pm'),
                    SessionsDateButton(dateAndTime: '2 April - 2:30 PM'),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// Build / Booking - Location - Save Buttons
class Buttons extends StatelessWidget {
  Buttons({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String? title;
  final Icon? icon;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            /// On Tap Routes.
          },
          child: CircleAvatar(
            backgroundColor: const Color.fromRGBO(22, 92, 144, 1.0),
            maxRadius: 24,
            child: icon,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

/// Build Nearest Avaliable Dates Buttons
class SessionsDateButton extends StatelessWidget {
  SessionsDateButton({
    required this.dateAndTime,
    this.onPressed,
  });
  final String? dateAndTime;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145.w,
      height: 40.h,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color.fromRGBO(255, 224, 178, 0.75),
          shadowColor: const Color.fromRGBO(171, 130, 8, 0.20),
        ),
        onPressed: () {},
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            dateAndTime!,
            style: const TextStyle(
              color: Color.fromRGBO(105, 65, 3, 1),
            ),
          ),
        ),
      ),
    );
  }
}
