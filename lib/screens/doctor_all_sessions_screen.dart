import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentcare/screens/add_appointment_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/doctors_provider.dart';

class DoctorAllSessions extends StatefulWidget {
  const DoctorAllSessions({Key? key}) : super(key: key);

  static const routeName = '/all-sessions';

  @override
  State<DoctorAllSessions> createState() => _DoctorAllSessionsState();
}

class _DoctorAllSessionsState extends State<DoctorAllSessions> {
  var formatter = DateFormat('MM-dd, hh:mm a');
  bool isLoading = true;
  @override
  void initState() {
    fetchUnbookedSessions();
    super.initState();
  }

  Future<void> fetchUnbookedSessions() async {
    final doctorId = FirebaseAuth.instance.currentUser!.uid;
    // send the doctor id here
    await Provider.of<DoctorsDataProvider>(context, listen: false)
        .fetchSessions('4EF9gpHqfjbOMTDmF4aFuKcHZax1')
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> deleteSession(String sessionId) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure you want to delete this session ?'),
            actions: [
              TextButton(
                onPressed: () async {
                  await Provider.of<DoctorsDataProvider>(context, listen: false)
                      .deleteSession(sessionId)
                      .then(
                        (value) => Navigator.of(context).pop(),
                      );
                },
                child: const Text(
                  'delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('cancel'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final sessions = Provider.of<DoctorsDataProvider>(context).sessions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('unbooked sessions'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.grey,
            ))
          : sessions.isEmpty
              ? const Center(
                  child: Text(
                    'You don`t have any free\n appointments',
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
                            return Card(
                              color: index % 2 == 0
                                  ? const Color.fromARGB(225, 196, 230, 255)
                                  : const Color.fromARGB(213, 216, 234, 255),
                              margin: const EdgeInsets.all(12),
                              child: ListTile(
                                title: Text(
                                    'Time : ${formatter.format(sessions[index].dateAndTime)}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await deleteSession(sessions[index].id);
                                  },
                                ),
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
