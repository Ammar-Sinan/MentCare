import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../providers/doctors_provider.dart';

class ScheduledSessionsScreen extends StatefulWidget {
  //const ScheduledSessionsScreen({Key? key}) : super(key: key);
  static const routeName = '/scheduled-sessions';

  @override
  State<ScheduledSessionsScreen> createState() =>
      _ScheduledSessionsScreenState();
}

class _ScheduledSessionsScreenState extends State<ScheduledSessionsScreen> {
  var formatter = DateFormat('MM-dd hh:mm');
  @override
  void initState() {
    fetchSessions();
    super.initState();
  }

  Future<void> fetchSessions() async {
    //final userId = FirebaseAuth.instance.currentUser!.uid;
    await Provider.of<DoctorsDataProvider>(context, listen: false)
        .fetchBookedSessions('userId');
  }

  @override
  Widget build(BuildContext context) {
    final sessionInfo =
        Provider.of<DoctorsDataProvider>(context).doctorDashBoardSessions;

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
          'Scheduled appointments',
          style: TextStyle(fontSize: 19),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sessionInfo.length,
            itemBuilder: (BuildContext context, int index) {
              var textStyle = TextStyle(
                  color: index % 2 == 0
                      ? const Color.fromARGB(255, 150, 150, 150)
                      : const Color.fromARGB(255, 30, 80, 128),
                  fontSize: 16);
              return Container(
                padding: const EdgeInsets.all(12),
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                width: double.infinity.w,
                decoration: BoxDecoration(
                  color: index % 2 == 0
                      ? Colors.white
                      : const Color.fromRGBO(156, 184, 245, 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: const Color.fromRGBO(156, 184, 245, 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doctor name : ${sessionInfo[index].doctorNAme}',
                      style: const TextStyle(
                          fontSize: 17, color: Color.fromARGB(255, 11, 34, 53)),
                    ),
                    Text(
                      DateFormat.yMMMMEEEEd().format(
                        sessionInfo[index].time,
                      ),
                      style: textStyle,
                    ),
                    Text(
                      'Location : ${sessionInfo[index].isClinic ? 'Clinic' : 'Online'}',
                      style: textStyle,
                    ),
                    Text(
                      'cost : ${sessionInfo[index].price}\$',
                      style: textStyle,
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
