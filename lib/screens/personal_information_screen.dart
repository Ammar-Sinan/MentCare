import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentcare/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/edit_profile_image.dart';
import '../widgets/settings_listtile.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  static const routeName = '/personal-information';

  @override
  State createState() => PersonalInformationState();
}

class PersonalInformationState extends State<PersonalInformation> {
  // ignore: prefer_typing_uninitialized_variables
  late final user;
  bool isLoading = false;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // ignore: prefer_final_fields
  List<Map<String, dynamic>> _settingsList = [
    {
      'title': 'Name',
      'icon': const Icon(Icons.account_circle_outlined),
      'subTitle': '',
      'fireBaseName': 'fullName'
    },
    {
      'title': 'Phone Number',
      'icon': const Icon(Icons.phone),
      'subTitle': '',
      'fireBaseName': 'phoneNumber'
    },
    {
      'title': 'Email',
      'icon': const Icon(Icons.email_outlined),
      'subTitle': '',
      'fireBaseName': 'email'
    },
    {
      'title': 'Change Password',
      'icon': const Icon(Icons.password_outlined),
      'subTitle': '',
      'fireBaseName': ''
    },
  ];

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    getUserData();

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(width, height),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 32.h,
          ),
          GestureDetector(
            child: FutureBuilder(
                builder: (cnt, AsyncSnapshot snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.data!['profileImageUrl'] == '') {
                      return const Text('add profile picture...');
                    } else {
                      return CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data!['profileImageUrl']),
                      );
                    }
                  }
                },
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get()),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (cnt) => const SimpleDialog(children: [
                        EditProfileImage('users'),
                      ]));
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (cnt, index) => SettingsListTile(
              icon: _settingsList[index]['icon'],
              title: _settingsList[index]['title'],
              subtitle: _settingsList[index]['subTitle'],
              fireBaseName: _settingsList[index]['fireBaseName'],
            ),
            itemCount: 4,
          )),
        ],
      ),
    );
  } // build

  void getUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserData();
    dynamic user = userProvider.userData;
    _settingsList[0]['subTitle'] = user['fullName'];
    _settingsList[1]['subTitle'] = user['phoneNumber'];
    _settingsList[2]['subTitle'] = user['email'];

    setState(() {});
  }
}
