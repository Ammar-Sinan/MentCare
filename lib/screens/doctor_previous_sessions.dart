import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/doctors_provider.dart';

class DoctorPreviousSessions extends StatelessWidget {
  DoctorPreviousSessions({Key? key}) : super(key: key);

  static const routeName = '/doctor-previous-sessions';

  var formatter = DateFormat('MM-dd, hh:mm a');

  @override
  Widget build(BuildContext context) {
    final sessions = Provider.of<DoctorsDataProvider>(context)
        .appointmentsFilter('Previous');

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
        title: const Text(
          'Previous sessions',
          style: TextStyle(fontSize: 19),
        ),
      ),
      body: sessions.isEmpty
          ? const Center(
              child: Text(
                'You don`t have any previous\n appointments',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                ),
                textAlign: TextAlign.center,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: sessions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          color: index % 2 == 0
                              ? const Color.fromARGB(225, 196, 230, 255)
                              : const Color.fromARGB(213, 216, 234, 255),
                          margin: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Patient name : ${sessions[index].userName}',
                                style: const TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'Time : ${formatter.format(sessions[index].time)}',
                                style: const TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                  'Location : ${sessions[index].isClinic ? 'Clinic' : 'Online'}',
                                  style: const TextStyle(fontSize: 15))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
