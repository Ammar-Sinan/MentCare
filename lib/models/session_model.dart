import 'package:cloud_firestore/cloud_firestore.dart';

class SessionData {
  String id;
  Timestamp dateAndTime;
  String location; // might use boolean for this

  SessionData({
    required this.id,
    required this.dateAndTime,
    required this.location,
  });
}
