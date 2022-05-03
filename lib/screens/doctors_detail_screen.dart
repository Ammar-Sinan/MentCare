import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../widgets/reviews_card_dr_detail.dart';

import '../providers/doctors_provider.dart';

class DoctorDetails extends StatefulWidget {
  static const routeName = '/doctor-detail';

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  Color iconColor = Colors.white;
  bool isSaved = false;

  TextStyle textStyle =
      const TextStyle(fontSize: 19.2, fontWeight: FontWeight.w400);

  Container buildSpecialityChips(BuildContext context, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      padding: const EdgeInsets.all(6),
      color: const Color.fromRGBO(212, 229, 241, 0.3),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(label, style: Theme.of(context).textTheme.bodyText1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctorId = ModalRoute.of(context)!.settings.arguments as String;
    final doctorData = Provider.of<DoctorsDataProvider>(context, listen: false)
        .findById(doctorId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(212, 229, 241, 1.0),
        elevation: 5,
        actions: [
          Builder(builder: (ctx) {
            return IconButton(
              onPressed: () {
                Provider.of<DoctorsDataProvider>(context, listen: false)
                    .toggleSaveStatus(doctorId);
              },
              icon: isSaved
                  ? const Icon(Icons.turned_in)
                  : const Icon(Icons.turned_in_not),
            );
          }),
          // IconButton(
          //   onPressed: () {},
          //   icon: isSaved
          //       ? const Icon(Icons.favorite)
          //       : const Icon(Icons.favorite_border),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                      Text(
                        doctorData.name,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w300),
                      ),
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
                              title: 'Book',
                              icon: Icon(Icons.calendar_today_outlined,
                                  color: iconColor),
                              route: '1'),
                          Buttons(
                              title: 'location',
                              icon: Icon(Icons.location_on_outlined,
                                  color: iconColor),
                              route: '2'),
                          // Buttons(
                          //     title: 'save',
                          //     icon: Icon(Icons.archive_outlined,
                          //         color: iconColor),
                          //     route: '3'),
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
                  Text(
                    'Nearest available dates',
                    style: textStyle,
                  ),
                  Row(
                    children: const [
                      SessionsDateButton(dateAndTime: '29 Mar - 4:00 Pm'),
                      SessionsDateButton(dateAndTime: '2 April - 2:30 PM'),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'specialised in',
                    style: textStyle,
                  ),
                  Row(
                    children: [
                      /// Thinking Out Loud ==>
                      /// TextFields for DR in these Whenever he Adjust that
                      /// It triggers a method in the provider to fetch them
                      buildSpecialityChips(context, 'Addiction'),
                      buildSpecialityChips(context, 'Anxiety disorders'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Education',
                    style: textStyle,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        height: 90.h,
                        width: 90.w,
                        color: Colors.amber,
                        child: const Text('/Uni Logo'),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        children: const [
                          Text('doctorData.university'),
                          SizedBox(width: 16),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
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
  bool isSaved = false;

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
        const SizedBox(height: 8),
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
  const SessionsDateButton({
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(255, 224, 178, 0.75),
            shadowColor: const Color.fromRGBO(171, 130, 8, 0.20)),
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
