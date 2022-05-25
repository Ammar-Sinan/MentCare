import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentcare/models/booked_sessions.dart';
import 'package:mentcare/models/session_model.dart';

import '../providers/doctor_model.dart';

class DoctorsDataProvider with ChangeNotifier {
  List<DoctorData> _cardInfo = [];

  List<DoctorData> _savedList = [];

  List<SessionData> _sessions = [];

  List<DoctorData> get cardInfo {
    return [..._cardInfo];
  }

  List<DoctorData> get savedList {
    return [..._savedList];
  }

  List<SessionData> get sessions {
    return [..._sessions];
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
          specialisedIn: element['specialisedIn'],
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
          specialisedIn: element['specialisedIn'],
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
    List savedDoctors = [doctorId];

    await userDoc.update({
      'savedDoctors': FieldValue.arrayUnion(savedDoctors),
    });
  }

  Future<String> fetchDoctorName() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    dynamic doctor =
        await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
    return doctor['name'];
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
        .collection('doctors')
        .where('id', whereIn: savedDoctors)
        .get();

    List getSavedDoctors = doctors.docs.map((element) {
      return element.data();
    }).toList();

    List<DoctorData> savedDoctor = [];

    for (var element in getSavedDoctors) {
      savedDoctor.add(
        DoctorData(
          id: element['id'],
          name: element['name'],
          price: element['price'],
          category: element['category'],
          university: element['university'],
          major: element['major'],
          specialisedIn: element['specialisedIn'],
        ),
      );
    }

    _savedList = savedDoctor;
    notifyListeners();
  }

  Future<void> fetchSessions() async {
    final sessions = await FirebaseFirestore.instance
        .collection('doctors')
        .doc('4EF9gpHqfjbOMTDmF4aFuKcHZax1')
        .collection('sessions')
        .get();

    // DocumentReference docRefrence = FirebaseFirestore.instance
    //     .collection('doctors')
    //     .doc('XeTEDjSuQBEj6T0cT65s');

    // DocumentSnapshot docSnap = await docRefrence.get();
    // var docId = docSnap.reference.id;
    // print(docRefrence);
    // print(docId);

    List avaliableSession = sessions.docs.map((e) => e.data()).toList();

    List<SessionData> unBookedSessions = [];

    for (var element in avaliableSession) {
      unBookedSessions.add(
        SessionData(
          id: element['id'],
          dateAndTime: element['time'].toDate(),
        ),
      );
    }

    _sessions = unBookedSessions;
    notifyListeners();
  }


  Future<dynamic> fetchDoctorData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance.collection('doctors')
        .doc(uid)
        .get();
  }

  Future<void> bookSession(BookedSessions sessionInfo) async {
    var bookedSessionInfo = {
      'id': sessionInfo.id,
      'drName': sessionInfo.drName,
      'userId': sessionInfo.userId,
      'userName': sessionInfo.userName,
      'isOnline': sessionInfo.isOnline,
      'isClinic': sessionInfo.isClinic,
      'time': sessionInfo.time,
      'details': sessionInfo.details,
    };
    await FirebaseFirestore.instance
        .collection('bookedSessions')
        .add(bookedSessionInfo);

    // await FirebaseFirestore.instance
    //     .collection('doctors')
    //     .doc('4EF9gpHqfjbOMTDmF4aFuKcHZax1')
    //     .update({'isBooked': true});
  }
}




    // DocumentReference docRefrence =
    //     FirebaseFirestore.instance.collection('doctors').doc(doctorId);

    // DocumentSnapshot docSnap = await docRefrence.get();
    // var docId = docSnap.reference.id;
    // print(docRefrence);
    // print(docId);