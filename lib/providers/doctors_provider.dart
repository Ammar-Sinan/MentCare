import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/doctor_model.dart';

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

    for (var element in data) {
      doctorsData.add(
        DoctorData(
          id: element['id'],
          category: element["category"],
          isSaved: false,
          name: element["name"],
          price: element["price"],
          specialtyShort: ['Addiction'], // Add the field name in Firebase
        ),
      );
    }
    _cardInfo = doctorsData;
    notifyListeners();
  }

  get length => _cardInfo.length;

  List<DoctorData> showCategory(String cat) {
    return _cardInfo.where((element) {
      return element.category == cat;
    }).toList();
  }

  Future<void> searchByDoctorName(String name) async {
    QuerySnapshot doctors;
    doctors = await FirebaseFirestore.instance
        .collection("doctors")
        .where("name", whereIn: [name]).get();
    List? data;
    data = doctors.docs.map((e) {
      return e.data();
    }).toList();
    final List<DoctorData> doctorsData = [];

    // ignore: avoid_function_literals_in_foreach_calls
    data.forEach((element) {
      doctorsData.add(
        DoctorData(
          id: element["id"],
          category: element["category"],
          isSaved: false,
          name: element["name"],
          price: element["price"],
          specialtyShort: ['Addiction'], // Add the field name in Firebase
        ),
      );
    });
    _cardInfo = doctorsData;
    notifyListeners();
  }

  DoctorData findById(String id) {
    return _cardInfo.firstWhere((element) => element.id == id);
  }

  void toggleSaveStatus(String doctorId) {
    final currUserId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(currUserId);

    /// Creating a list here only because .arrayUnion() takes a List not a string
    /// and the doctorId by itself is a String
    List test = [doctorId];
    userDoc.update({
      'savedDoctors': FieldValue.arrayUnion(test),
    });

    print(currUserId);
  }
}
