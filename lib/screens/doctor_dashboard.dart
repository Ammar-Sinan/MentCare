import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/add_appointment_screen.dart';

import '../providers/doctors_provider.dart';

import '../widgets/dr_dashboard_cards.dart';

class DoctorDashboard extends StatefulWidget {
  //const DoctorDashboard({Key? key}) : super(key: key);
  static const routeName = '/doctor-dashboard';

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  bool isLoading = true;
  DateTime now = DateTime.now();
  var formatter = DateFormat('MM-dd LLLL');
  bool filterHelper = false;
  String filter = '';

  @override
  void initState() {
    fetchSessions();
    super.initState();
  }

  Future<void> fetchSessions() async {
    setState(() {
      Provider.of<DoctorsDataProvider>(context, listen: false)
          .fetchBookedSessions()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  //Filters Buttons
  OutlinedButton buildFilterButtons(String label) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          filterHelper = !filterHelper;
          filter = label;
        });
      },
      child: Text(
        label,
        // style: const TextStyle(color: Color.fromARGB(255, 214, 158, 37)),
      ),
      style: ElevatedButton.styleFrom(
          onPrimary: const Color.fromARGB(255, 33, 142, 206),
          onSurface: Colors.amber,
          side: const BorderSide(
            color: Color.fromARGB(255, 168, 168, 168),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionsProvider = Provider.of<DoctorsDataProvider>(context);

    var sessions = filterHelper
        ? sessionsProvider.appointmentsFilter(filter)
        : sessionsProvider.doctorDashBoardSessions;

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

    return SafeArea(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatter.format(now)),
                      ElevatedButton(
                        child: const Text(
                          'Add appointment',
                          style: TextStyle(color: Color(0xFF694103)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AddAppointment.routeName);
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFFFE0B2)),
                        ),
                      )
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  // Building the Filter Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildFilterButtons('clinic'),
                      buildFilterButtons('online'),
                      buildFilterButtons('previous'),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  Text(
                    'Booked Sessions :  ${sessions.length.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 241, 241, 241),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: sessions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChangeNotifierProvider.value(
                            value: sessions[index],
                            child: BuildDashboardCard(index: index),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
