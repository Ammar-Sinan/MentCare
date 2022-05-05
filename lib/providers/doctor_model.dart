import 'package:flutter/material.dart';

class DoctorData with ChangeNotifier {
  final String id;
  final String name;
  final String price;
  final String category;
  final String university;
  final String major;
  final List<String> specialityShort;

  bool isSaved;

  DoctorData({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.specialityShort,
    required this.university,
    required this.major,
    this.isSaved = false,
  });
}
