import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  dynamic user;
  String profileImage='';

  Future<void> fetchUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    user = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    ChangeNotifier();
  }

  Future<String> fetchUserId() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<String> fetchUserName() async {
    await fetchUserData();
    return user['fullName'];
  }

  Future<void> updateField(
      String userID, String fireBaseName, String input, String userRole) async {
    await FirebaseFirestore.instance
        .collection(userRole)
        .doc(userID)
        .update({fireBaseName: input});
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: oldPassword);
    await FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential);
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
  }


  // TODO this is for updating profile picture DON'T DELETE THE CODE
  // void updateProfilePicture(String collectionName,File pImage) async {
  //
  //   String imageUrl = '';
  //   String userId = FirebaseAuth.instance.currentUser!.uid;
  //   final ref = FirebaseStorage.instance.ref().child('profilePictures').child(
  //       userId + '.jpg');
  //   await ref.putFile(pImage).whenComplete(() async
  //   {
  //     imageUrl = await ref.getDownloadURL();
  //     profileImage = imageUrl;
  //     notifyListeners();
  //   });
  //   await FirebaseFirestore.instance.collection(collectionName).doc(userId).update({'profileImageUrl':imageUrl});
  // }
  //
  // String getProfilePicture()
  // {
  //   return profileImage;
  // }
  //
  // void fetchProfilePicture({required String collectionName}) async
  // {
  //   final id = FirebaseAuth.instance.currentUser!.uid;
  //   final doc = await FirebaseFirestore.instance.collection(collectionName).doc(id).get();
  //
  //   if (doc['profileImageUrl'] != null) {
  //
  //     profileImage =  doc['profileImageUrl'];
  //   }
  //   notifyListeners();
  // }

  dynamic get userData => user;
}
