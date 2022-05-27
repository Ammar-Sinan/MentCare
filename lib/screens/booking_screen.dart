import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentcare/models/booked_sessions.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../providers/doctors_provider.dart';

class BookingScreen extends StatefulWidget {
  //const BookingScreen({Key? key}) : super(key: key);

  static const routeName = '/booking';

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController details = TextEditingController();

  bool isOnlinePressed = false;
  bool isClinicPressed = false;
  final DateFormat formatter = DateFormat('MM-dd, hh:mm');

  // Text Fields decoration
  InputDecoration textFieldDecoration(BuildContext context, String label) {
    return InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(8),
      label: Text(
        label,
        style: const TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 223, 223, 223), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    name = TextEditingController();
    phoneNumber = TextEditingController();
    details = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    phoneNumber.dispose();
    details.dispose();
    super.dispose();
  }

  // Alert dialog for booking a session
  Future<void> buildBookingDuialog(String title, String content) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              title,
              style: const TextStyle(color: Color.fromARGB(255, 117, 117, 117)),
            ),
            content: Text(content),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor)),
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // bookSession method
  Future<void> bookSession(BuildContext context) async {
    var sessionDates = ModalRoute.of(context)!.settings.arguments as List;

    final userId = FirebaseAuth.instance.currentUser!.uid;
    if (name.text.isEmpty) {
      buildBookingDuialog('please provide your name', '');
    } else if (isOnlinePressed == false && isClinicPressed == false) {
      buildBookingDuialog('choose a location', '');
    } else {
      BookedSessions bookedSessionInfo = BookedSessions(
        id: sessionDates[1], // Session ID
        userName: name.text,
        userId: userId,
        drName: sessionDates[2], // Doctor ID
        isOnline: isOnlinePressed,
        isClinic: isClinicPressed,
        time: sessionDates[0],
        details: details.text,
        phoneNum: phoneNumber.text,
      );

      try {
        await Provider.of<DoctorsDataProvider>(context, listen: false)
            .bookSession(bookedSessionInfo);
        await buildBookingDuialog('A session has been successfully booked', '');
      } catch (error) {
        await buildBookingDuialog('Could not complete your booking request!',
            'please try again later');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Getting the session data [id, dateAndTime , location] in a list
    var sessionDatess = ModalRoute.of(context)!.settings.arguments as List;

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text(
                'Complete booking process',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 12.h,
              ),

              ///${sessionDatess[0].toString()}
              Text(
                'session at\n ${formatter.format(sessionDatess[0])}',
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: name,
                onSubmitted: (value) => name.text = value,
                textInputAction: TextInputAction.next,
                decoration: textFieldDecoration(context, 'name'),
                autofocus: true,
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: phoneNumber,
                keyboardType: TextInputType.number,
                onSubmitted: (value) => phoneNumber.text = value,
                textInputAction: TextInputAction.next,
                decoration:
                    textFieldDecoration(context, 'phone number - optional'),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: details,
                onSubmitted: (value) => details.text = value,
                textInputAction: TextInputAction.next,
                decoration: textFieldDecoration(context,
                    'Anything you want your therapist\nto know before your next session ?'),
                maxLines: 5,
              ),
              SizedBox(
                height: 16.h,
              ),
              const Text(
                'where do you want to have\n the session :',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Online Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: isOnlinePressed
                            ? const Color(0xFFECECEC)
                            : Colors.white),
                    onPressed: () {
                      setState(() {
                        isOnlinePressed = !isOnlinePressed;
                        isClinicPressed = false;
                      });
                    },
                    child: Text(
                      'Online',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),

                  /// Clinic Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: isClinicPressed
                            ? const Color(0xFFECECEC)
                            : Colors.white),
                    onPressed: () {
                      setState(() {
                        isClinicPressed = !isClinicPressed;
                        isOnlinePressed = false;
                      });
                    },
                    child: Text(
                      'Clinic',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Add payment method',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).primaryColor,
                        fontSize: 16,
                        color: Colors.lightBlueAccent),
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  child: const Text('Finish Booking'),
                  onPressed: () {
                    bookSession(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
