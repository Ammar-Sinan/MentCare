import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileImage extends StatefulWidget {
  const EditProfileImage(this.collectionName, {Key? key}) : super(key: key);

  final String collectionName;

  @override
  _EditProfileImageState createState() => _EditProfileImageState();
}

class _EditProfileImageState extends State<EditProfileImage> {
  File? profileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        height: 300,
        width: 150,
        child: Column(
          children: [
            Text('Change the image:'),
            SizedBox(
              height: 50,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                  child: GestureDetector(
                    child: Column(
                      children: [
                        Text('local device'),
                        Icon(Icons.devices_outlined)
                      ],
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                    onTap: () {
                      pickImage(ImageSource.gallery, widget.collectionName);
                      Navigator.of(context).pop();
                    },
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(20)),
                )),
                Expanded(
                  child: Container(
                    child: GestureDetector(
                      child: Column(children: [
                        Text('take a photo'),
                        Icon(Icons.camera_alt)
                      ]),
                      onTap: () {
                        pickImage(ImageSource.camera, widget.collectionName);
                        Navigator.of(context).pop();
                      },
                    ),
                    decoration: BoxDecoration(color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 5),
                  ),
                )
              ],
            )
          ],
        ));
  }

  void pickImage(ImageSource imageSource, String collectionName) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(
        source: imageSource, imageQuality: 100, maxWidth: 200, maxHeight: 200);
    if (xFile == null) return;

    final profileImage = File(xFile.path);

    String imageUrl = '';
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance
        .ref()
        .child('profilePictures')
        .child(userId + '.jpg');
    await ref.putFile(profileImage).whenComplete(() async {
      imageUrl = await ref.getDownloadURL();
    });
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(userId)
        .update({'profileImageUrl': imageUrl});
  }
}
