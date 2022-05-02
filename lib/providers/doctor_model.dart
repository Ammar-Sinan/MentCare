import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorData with ChangeNotifier {
  CollectionReference savedStatus =
      FirebaseFirestore.instance.collection('doctors');

  final String id;
  final String name;
  final String price;
  final String category;
  final List<String> specialtyShort;

  bool isSaved = false;

  DoctorData({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.specialtyShort,
    required this.isSaved,
  });

  Future<void> toggleSaveStatus() async {
    final oldStatus = isSaved;
    isSaved = !isSaved;
    notifyListeners();
    return savedStatus.doc().update({'isSaved': isSaved});
  }
}
