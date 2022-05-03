import 'package:flutter/material.dart';

class DoctorData with ChangeNotifier {
  final String id;
  final String name;
  final String price;
  final String category;
  final List<String> specialtyShort;

  bool isSaved;

  DoctorData({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.specialtyShort,
    this.isSaved = false,
  });
}
