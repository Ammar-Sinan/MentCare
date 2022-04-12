import 'package:flutter/material.dart';

class DoctorData with ChangeNotifier {
  final String id;
  final String name;
  final String price;
  final String category;
  bool isSaved = false;

  DoctorData(
      {required this.id,
      required this.name,
      required this.price,
      required this.category,
      required this.isSaved});
}
