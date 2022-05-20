import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentcare/models/booked_sessions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/doctors_provider.dart';

enum sessionLocation { online, clinic }

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

  Future<void> bookSession(BuildContext context) async {
    //var sessionDate = ModalRoute.of(context)!.settings.arguments as List;

    final userId = FirebaseAuth.instance.currentUser!.uid;
    if (name.text.isEmpty) {
      print('Please provide your name');
    } else {
      BookedSessions bookedSessionInfo = BookedSessions(
        id: 'sessionDate[1]',
        userName: name.text,
        userId: userId,
        drName: 'drName',
        isOnline: isOnlinePressed,
        isClinic: isClinicPressed,
        time: DateTime.now(),
        details: details.text,
      );
      Provider.of<DoctorsDataProvider>(context, listen: false)
          .bookSession(bookedSessionInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Getting the session data [id, dateAndTime , location] in a list
    var sessionDates = ModalRoute.of(context)!.settings.arguments as List;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete booking process',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                'session at\n ${sessionDates[0].toString()}',
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
                'where do you want\nto have the session :',
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
                      });
                    },
                    child: Text(
                      'Clinic',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
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
