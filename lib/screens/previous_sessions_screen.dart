import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PreviousSessions extends StatelessWidget {
  PreviousSessions({Key? key}) : super(key: key);
  static const routeName = '/previous-sessions';

  List previousSessions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Previous sessions',
          style:
              TextStyle(fontSize: 19.2, color: Theme.of(context).primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: previousSessions.length,
          itemBuilder: (context, index) {
            return Container();
          },
        ),
        // child:
      ),
    );
  }
}

class PreviousSessionsListTile extends StatelessWidget {
  const PreviousSessionsListTile(
      {Key? key, required this.date, required this.drName, required this.cost})
      : super(key: key);

  final String date;
  final String drName;
  final String cost;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        date,
        style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor),
      ),
      subtitle: Text(
        drName,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        cost,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor),
      ),
    );
  }
}
