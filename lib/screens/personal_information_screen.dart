import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/settings_listtile.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  static const routeName = '/personal-information';

  @override
  Widget build(BuildContext context) {
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
          const SettingsListTile(
            title: 'Profile picture',
            subtitle: '',
            icon: Icon(Icons.account_circle),
            route: '',
          ),
          const SettingsListTile(
            title: 'Name',
            subtitle: '',
            icon: Icon(Icons.account_circle_outlined),
            route: '',
          ),
          const SettingsListTile(
            title: 'Phone number',
            subtitle: '079',
            icon: Icon(Icons.phone_android_outlined),
            route: '',
          ),
          const SettingsListTile(
            title: 'Email',
            subtitle: '@.com',
            icon: Icon(Icons.email_outlined),
            route: '',
          ),
          const SettingsListTile(
            title: 'Change password',
            subtitle: '',
            icon: Icon(Icons.lock_clock_outlined),
            route: '',
          ),
        ],
      ),
    );
  }
}
