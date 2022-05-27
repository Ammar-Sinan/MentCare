import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ScheduledSessionsScreen extends StatefulWidget {
  //const ScheduledSessionsScreen({Key? key}) : super(key: key);
  static const routeName = '/scheduled-sessions';

  @override
  State<ScheduledSessionsScreen> createState() =>
      _ScheduledSessionsScreenState();
}

class _ScheduledSessionsScreenState extends State<ScheduledSessionsScreen> {
  @override
  void initState() {
    fetchSessions();
    super.initState();
  }

  void fetchSessions() {
    // Provider.of<UserProvider>(context, listen: false).fetchScheduledSessions();
  }

  @override
  Widget build(BuildContext context) {
    final sessionInfo =
        Provider.of<UserProvider>(context, listen: false).bookedSessions;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled sessions'),
      ),
      body: Column(children: [
        Text(sessionInfo[0].userName),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sessionInfo.length,
            itemBuilder: (BuildContext context, int index) {
              return const ListTile(
                title: Text('sessionInfo[index].drName'),
              );
            },
          ),
        ),
      ]),
    );
  }
}
