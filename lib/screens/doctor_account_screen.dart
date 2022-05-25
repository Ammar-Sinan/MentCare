import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/user_account_listtile.dart';

class DoctorAccountScreen extends StatefulWidget {
  const DoctorAccountScreen({Key? key}) : super(key: key);
  static const routeName = '/doctorAccount';

  @override
  State createState() => DoctorAccountScreenState();
}

class DoctorAccountScreenState extends State<DoctorAccountScreen> {
  static const List<Map<String, dynamic>> _settingsList = [
    {
      'title': 'Personal Information',
      'icon': Icon(Icons.account_circle_outlined),
      'route': '/doctor-personal-information',
      'id': '01'
    },
    {
      'title': 'Scheduled sessions',
      'icon': Icon(Icons.schedule_outlined),
      'route': 'ROUTE3',
      'id': '02'
    },
    {
      'title': 'Previous sessions',
      'icon': Icon(Icons.swap_horizontal_circle_outlined),
      'route': 'ROUTE4',
      'id': '03'
    },
    {
      'title': 'Notifications',
      'icon': Icon(Icons.notifications_active),
      'route': 'ROUTE5',
      'id': '04'
    },
  ];

  String name = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    getUserName();
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(width, height),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, bottom: 8.h, top: 40.h),
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(
                    name,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w, bottom: 12.h),
            child: Text('Your account',
                style: Theme.of(context).textTheme.bodyText2),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (con, index) => SettingsListTile(
                  title: _settingsList[index]['title'],
                  icon: _settingsList[index]['icon'],
                  route: _settingsList[index]['route'],
                  id: _settingsList[index]['id']),
              itemCount: 4,
            ),
          ),
          Align(
            child: ListTile(
              title: const Text("Log out"),
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
            alignment: Alignment.topRight,
          )
        ],
      ),
    );
  }

  void getUserName() async {
    setState(() {
      isLoading = false;
    });
    // ToDo
    // name =
    //     await Provider.of<DoctorsDataProvider>(context, listen: false).fetchUserName();
    setState(() {
      isLoading = true;
    });
  }
}
