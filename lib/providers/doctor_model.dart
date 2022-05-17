import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorData with ChangeNotifier {
  final String id;
  final String name;
  final String price;
  final String category;
  final String university;
  final String major;
  final List<dynamic> specialisedIn;

  bool isSaved;

  DoctorData({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.specialisedIn,
    required this.university,
    required this.major,
    this.isSaved = false,
  });

  Future<void> saveDoctor(String doctorId) async {
    final oldStatus = isSaved;
    isSaved = !isSaved;
    notifyListeners();

    DocumentReference docRefrence =
        FirebaseFirestore.instance.collection('doctors').doc(doctorId);

    DocumentSnapshot docSnap = await docRefrence.get();
    var docId = docSnap.reference.id;
  }
}
