import 'package:flutter/material.dart';

import '../dummy_data/doctor_card_data.dart';

class DoctorsDataProvider with ChangeNotifier {
  final List<DoctorData> _cardInfo = [
    DoctorData(
      id: '01',
      price: '50-hr',
      category: 'CBT',
      name: 'John',
      isSaved: false,
    ),
    DoctorData(
      id: '02',
      price: '60',
      category: 'Couples',
      name: 'Jeremy',
      isSaved: false,
    ),
  ];

  List<DoctorData> get cardInfo {
    return [..._cardInfo];
  }

  get length => _cardInfo.length;
}
