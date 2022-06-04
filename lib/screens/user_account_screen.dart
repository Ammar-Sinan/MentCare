import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/scheduled_session_screen.dart';

import '../widgets/user_account_listtile.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({Key? key}) : super(key: key);
  static const routeName = '/userAccount';

  @override
  State createState() => UserAccountScreenState();
}

class UserAccountScreenState extends State<UserAccountScreen> {
  static const List<Map<String, dynamic>> _settingsList = [
    {
      'title': 'Personal Information',
      'icon': Icon(Icons.account_circle_outlined),
      'route': '/personal-information',
      'id': '01'
    },
    {
      'title': 'Payment Method',
      'icon': Icon(Icons.credit_card),
      'route': 'AddCard',
      'id': '02'
    },
    {
      'title': 'Scheduled sessions',
      'icon': Icon(Icons.schedule_outlined),
      'route': ScheduledSessionsScreen.routeName,
      'id': '03'
    },
    {
      'title': 'Previous sessions',
      'icon': Icon(Icons.swap_horizontal_circle_outlined),
      'route': 'ROUTE4',
      'id': '04'
    },
  ];

  String name = '';
  bool isLoading = true;

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
                id: _settingsList[index]['id'],
              ),
              itemCount: _settingsList.length,
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

    name = await Provider.of<UserProvider>(context).fetchUserName();
    setState(() {
      isLoading = false;
    });
  }
}
