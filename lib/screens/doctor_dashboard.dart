import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('doctor dashboard'),
          TextButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('log out'))
        ]),
      ),
    );
  }
}
