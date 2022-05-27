import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
  DateTime date = DateTime.now();
  var formatter = DateFormat('MM/dd LLLL');

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

  @override
  Widget build(BuildContext context) {
    final sessions =
        Provider.of<DoctorsDataProvider>(context).doctorDashBoardSessions;

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
                      Text(formatter.format(date)),
                      ElevatedButton(
                        child: const Text('Add appointemtn'),
                        onPressed: () {},
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                  Expanded(
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
                ],
              ),
            ),
    );
  }
}
