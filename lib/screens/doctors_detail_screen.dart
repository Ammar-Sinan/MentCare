import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../widgets/reviews_card_dr_detail.dart';
import '../providers/doctors_provider.dart';

class DoctorDetails extends StatelessWidget {
  const DoctorDetails({Key? key}) : super(key: key);

  static const routeName = '/doctor-detail';

  //final drInfo = Provider.of<DoctorsDataProvider>(context);
  /// use provider to fetch dr info

  @override
  Widget build(BuildContext context) {
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
                          // profile picture of Dr
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
                    SizedBox(
                      height: 16.h,
                    ),
                    const Text(
                      'Dr mcregor',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    const Text(
                      'Cognitive Behavioral Therapy',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Buttons(
                            title: 'Booking',
                            icon: Icon(Icons.calendar_today_outlined,
                                color: Colors.white),
                            id: 1),
                        Buttons(
                            title: 'location',
                            icon: Icon(Icons.location_on_outlined,
                                color: Colors.white),
                            id: 2),
                        Buttons(
                            title: 'save',
                            icon: Icon(Icons.archive_outlined,
                                color: Colors.white),
                            id: 3),
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
              children: [
                SizedBox(
                  height: 480.h,
                ),
                const Text(
                  'Nearest available dates for sessions',
                  style: TextStyle(fontSize: 19.2, fontWeight: FontWeight.w400),
                ),
                // Call THe nearest available dates buttons here
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({Key? key, this.title, this.icon, this.id}) : super(key: key);
  final String? title;
  final Icon? icon;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (id == 1) {
              Navigator.of(context).pushNamed('/');
            } else if (id == 2) {
              // Navigate to the desired screen
            } else if (id == 3) {
              // Navigate to the desired screen
            }
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
