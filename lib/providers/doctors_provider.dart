import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/doctor_model.dart';

class DoctorsDataProvider with ChangeNotifier {
  List<DoctorData> _cardInfo = [];

  List<DoctorData> _savedList = [];

  List<DoctorData> get cardInfo {
    return [..._cardInfo];
  }

  List<DoctorData> get savedList {
    return [..._savedList];
  }

  get length => _cardInfo.length;

  get savedListength => _savedList.length;

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
          specialityShort: ['Addiction'],
          university: element['university'],
          major: element['major'],
        ),
      );
    }
    _cardInfo = doctorsData;
    notifyListeners();
  }

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
          specialityShort: ['Addiction'],
          university: element['university'],
          major: element['major'],
        ),
      );
    });
    _cardInfo = doctorsData;
    notifyListeners();
  }

  DoctorData findById(String id) {
    return _cardInfo.firstWhere((element) => element.id == id);
  }

  Future<void> toggleSaveStatus(String doctorId) async {
    final currUserId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(currUserId);

    /// Creating a list here only because .arrayUnion() takes a List not a
    /// string and the doctorId by itself is a String
    List test = [doctorId];
    userDoc.update({
      'savedDoctors': FieldValue.arrayUnion(test),
    });
  }

  Future<void> fetchUserSaved() async {
    final currUserId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currUserId)
        .get();

    List savedDoctors = userDoc['savedDoctors'];

    QuerySnapshot doctors;
    doctors = await FirebaseFirestore.instance
        .collection("doctors")
        .where('id', whereIn: savedDoctors)
        .get();

    List data = doctors.docs.map((element) {
      return element.data();
    }).toList();
    print(data);

    List<DoctorData> savedDoctor = [];

    for (var element in data) {
      savedDoctor.add(
        DoctorData(
          id: element['id'],
          name: element['name'],
          price: element['price'],
          category: element['category'],
          university: element['university'],
          major: element['major'],
          specialityShort: element['specialityShort'],
        ),
      );
    }

    _savedList = savedDoctor;
    notifyListeners();
    print(_savedList);
    print('LENGTH: ${_savedList.length}');
  }
}
