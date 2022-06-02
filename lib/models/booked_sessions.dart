import 'package:flutter/cupertino.dart';

class BookedSessions with ChangeNotifier {
  final String id;
  final String userName;
  final String userId;
  final String drName;
  final DateTime time;
  final bool isOnline;
  final bool isClinic;
  final String details;
  final String? phoneNum;

  BookedSessions({
    required this.id,
    required this.userName,
    required this.userId,
    required this.drName,
    required this.isOnline,
    required this.isClinic,
    required this.time,
    required this.details,
    this.phoneNum,
  });
}
