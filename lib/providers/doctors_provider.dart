import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'doctor_card_data.dart';

class DoctorsDataProvider with ChangeNotifier {
  List<DoctorData> _cardInfo = [];

  List<DoctorData> get cardInfo {
    return [..._cardInfo];
  }

  Future<void> fetchDoctorsList() async {

    QuerySnapshot doctors;
    doctors = await FirebaseFirestore.instance.collection("doctors").get();
    List? data;
    data = doctors.docs.map((e) {
        return e.data();
    }).toList();
    final List<DoctorData> doctorsData = [];

      data.forEach((element) {
      doctorsData.add(DoctorData(
          id: element["id"],
          category: element["category"],
          isSaved: true,
          name: element["name"],
          price: element["price"],
          specialtyShort: "_"));
    });
    _cardInfo = doctorsData;
    notifyListeners();
  }

  get length => _cardInfo.length;

  List<DoctorData> showCategory(String cat) {

      return _cardInfo.where((element) {
        return element.category == cat;
      }).toList();

  }

  Future<void> searchByDoctorName(String name) async{

    QuerySnapshot doctors;
    doctors = await FirebaseFirestore.instance.collection("doctors").where("name",whereIn: [name]).get();
    List? data;
    data = doctors.docs.map((e) {
      return e.data();
    }).toList();
    final List<DoctorData> doctorsData = [];

    data.forEach((element) {
      doctorsData.add(DoctorData(
          id: element["id"],
          category: element["category"],
          isSaved: true,
          name: element["name"],
          price: element["price"],
          specialtyShort: "_"));
    });
    _cardInfo = doctorsData;
    notifyListeners();

  }
}
