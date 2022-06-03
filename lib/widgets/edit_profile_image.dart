import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentcare/providers/user_provider.dart';
import 'package:provider/provider.dart';

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
    return Column(
      children: [
        Text('Do you want to change the image?'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: Column(children: [
                Text('local device'),
                Icon(Icons.devices_outlined)
              ]),
              onTap: () {
                pickImage(ImageSource.gallery, widget.collectionName);
                Navigator.of(context).pop();
              },
            ),
            GestureDetector(
              child: Column(
                  children: [Text('take a photo'), Icon(Icons.camera_alt)]),
              onTap: () {

                pickImage(ImageSource.camera, widget.collectionName);
                Navigator.of(context).pop();
              },
            ),
          ],
        )
      ],
    );
  }

  void pickImage(ImageSource imageSource, String collectionName) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(source: imageSource);
    if (xFile == null) return;

    final profileImage = File(xFile.path);

    String imageUrl = '';
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref().child('profilePictures').child(
        userId + '.jpg');
    await ref.putFile(profileImage).whenComplete(() async
    {
      imageUrl = await ref.getDownloadURL();

    });
    await FirebaseFirestore.instance.collection(collectionName).doc(userId).update({'profileImageUrl':imageUrl});



  }

}
