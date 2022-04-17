import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../dummy_data/doctor_card_data.dart';

class DoctorsDataProvider with ChangeNotifier {
   List<DoctorData> _cardInfo = [
    // DoctorData(
    //   id: '01',
    //   price: '50-hr',
    //   category: 'CBT',
    //   name: 'John',
    //   isSaved: false,
    // ),
    // DoctorData(
    //   id: '02',
    //   price: '60',
    //   category: 'Couples',
    //   name: 'Jeremy',
    //   isSaved: false,
    // ),
  ];

  List<DoctorData> get cardInfo {
    return [..._cardInfo];
  }

  Future<void> fetchDoctorDetails() async {
    QuerySnapshot doctors;
    doctors = await FirebaseFirestore.instance.collection("doctors").get();
    final List data = doctors.docs.map((e) => e.data()).toList();
    final List<DoctorData> doctorsData = [];
    data.forEach((element) {
      doctorsData.add(DoctorData(
          id: "0",
          category: element!["specialty_short"],
          isSaved: true,
          name: element["name"],
          price: element["price"],
      specialtyShort: element["specialty_short"]));
    });
    _cardInfo = doctorsData;
    print(doctorsData[0].name);
  }

  get length => _cardInfo.length;
}
