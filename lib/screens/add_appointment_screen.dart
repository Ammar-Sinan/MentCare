// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../screens/doctor_all_sessions_screen.dart';

import '../providers/doctors_provider.dart';

import '../models/session_model.dart';

class AddAppointment extends StatefulWidget {
  const AddAppointment({Key? key}) : super(key: key);
  static const routeName = '/add-appointment';

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  DateTime dateTime = DateTime.now();

  bool showDateTime = false;

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2023),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  // Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    if (date == null) return;

    final time = await _selectTime(context);

    if (time == null) return;
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String getDateTime() {
    if (dateTime == null) {
      return 'select date timer';
    } else {
      return DateFormat('yyyy-MM-dd HH:ss a').format(dateTime);
    }
  }

  Future<void> addAppointment() async {
    final sessionsProvider =
        Provider.of<DoctorsDataProvider>(context, listen: false);
    final addedSessionsIds = sessionsProvider.sessionsIds;

    // below if sttment was added when to check if the added session date
    //// already exists.. WIP
    if (addedSessionsIds.contains(dateTime)) {
      print('Session Already exist');
    }
    try {
      SessionData setAppointment = SessionData(dateAndTime: dateTime, id: '');
      await sessionsProvider.addAppointment(setAppointment);
      buildSnackBar('A new session was just added!');
    } catch (error) {
      print('Error caught in Widget : $error');
    }
  }

  SnackBar buildSnackBar(String label) {
    var snackBar = SnackBar(
      content: Text(label),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return snackBar;
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Add a new  appointment '),
            SizedBox(height: 40.h),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity.w,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  _selectDateTime(context);
                  showDateTime = true;
                },
                child: Text(
                  'Select Date and Time',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(194, 228, 254, 1)),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            const Text(
              'Date and time chosen :',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8.h),
            showDateTime
                ? Center(
                    child: Text(
                    getDateTime(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ))
                : const SizedBox(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(DoctorAllSessions.routeName);
                      },
                      child: const Text(
                        'view available appointments',
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(167, 96, 125, 139),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  SizedBox(
                    width: double.infinity.w,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: (() async {
                        if (dateTime.isAfter(DateTime.now())) {
                          await addAppointment();
                        } else {
                          buildSnackBar('Choose a date and time');
                        }
                      }),
                      child: const Text(
                        'Add Appointment',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
