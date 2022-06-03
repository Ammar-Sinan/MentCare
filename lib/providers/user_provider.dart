import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/booked_sessions.dart';

class UserProvider extends ChangeNotifier {
  final List<BookedSessions> _bookedSessions = [];

  dynamic user;

  List<BookedSessions> get bookedSessions {
    return [..._bookedSessions];
  }

  Future<void> fetchUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    user = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    ChangeNotifier();
  }

  Future<String> fetchUserId() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<String> fetchUserName() async {
    await fetchUserData();
    return user['fullName'];
  }

  Future<void> updateField(
      String userID, String fireBaseName, String input) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .update({fireBaseName: input});
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: oldPassword);
    await FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential);
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
  }

  dynamic get userData => user;

  Future<String> fetchDoctorName(String doctorId) async {
    final doctorName = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();
    return doctorName['name'];
  }
}
