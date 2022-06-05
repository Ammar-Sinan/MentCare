import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentcare/providers/doctors_provider.dart';
import 'package:mentcare/widgets/edit_profile_image.dart';
import 'package:provider/provider.dart';

import '../widgets/settings_listtile.dart';

class DoctorPersonalInformation extends StatefulWidget {
  const DoctorPersonalInformation({Key? key}) : super(key: key);

  static const routeName = '/doctor-personal-information';

  @override
  State createState() => DoctorPersonalInformationState();
}

class DoctorPersonalInformationState extends State<DoctorPersonalInformation> {
  // ignore: prefer_typing_uninitialized_variables
  late final user;
  bool isLoading = false;

  // ignore: prefer_final_fields
  List<Map<String, dynamic>> _settingsList = [
    {
      'title': 'Name',
      'icon': const Icon(Icons.account_circle_outlined),
      'subTitle': '',
      'fireBaseName': 'name'
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
    {
      'title': 'Gender',
      'icon': const Icon(Icons.male_outlined),
      'subTitle': '',
      'fireBaseName': 'gender'
    },
    {
      'title': 'Date Of Birth',
      'icon': const Icon(Icons.date_range_outlined),
      'subTitle': '',
      'fireBaseName': 'dateOfBirth'
    },
    {
      'title': 'Clinic Location',
      'icon': const Icon(Icons.location_on),
      'subTitle': '',
      'fireBaseName': 'clinicLocation'
    },
    {
      'title': 'Education',
      'icon': const Icon(Icons.padding),
      'subTitle': '',
      'fireBaseName': 'university'
    },
    {
      'title': 'speciality',
      'icon': const Icon(Icons.cast_for_education),
      'subTitle': '',
      'fireBaseName': 'specialisedIn'
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
    final doctorId = FirebaseAuth.instance.currentUser!.uid;

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
                      return SizedBox(
                        height: 100.h,
                        width: 100.w,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data!['profileImageUrl']),
                        ),
                      );
                    }
                  }
                },
                future: FirebaseFirestore.instance
                    .collection('doctors')
                    .doc(doctorId)
                    .get()),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (cnt) => const SimpleDialog(children: [
                        EditProfileImage('doctors'),
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
            itemCount: 9,
          )),
        ],
      ),
    );
  } // build

  void getUserData() async {
    final doctorProvider =
        Provider.of<DoctorsDataProvider>(context, listen: false);
    await doctorProvider.fetchDoctorData();
    dynamic doctor = await doctorProvider.fetchDoctorData();
    _settingsList[0]['subTitle'] = doctor['name'];
    _settingsList[1]['subTitle'] = doctor['phoneNumber'];
    _settingsList[2]['subTitle'] = doctor['email'];
    _settingsList[4]['subTitle'] = doctor['gender'];
    _settingsList[5]['subTitle'] = doctor['dateOfBirth'];
    _settingsList[6]['subTitle'] = doctor['clinicLocation'];
    _settingsList[7]['subTitle'] = doctor['university'];
    _settingsList[8]['subTitle'] = doctor['specialisedIn'].toString();

    setState(() {});
  }
}
