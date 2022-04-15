import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/user_account_listtile.dart';

class UserAccountScreen extends StatelessWidget {
  const UserAccountScreen({Key? key}) : super(key: key);
  static const routeName = '/userAccount';

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, bottom: 8.h, top: 40.h),
            child: Text(
              'Jeremy',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w, bottom: 12.h),
            child: Text('Your account',
                style: Theme.of(context).textTheme.bodyText2),
          ),
          const SettingsListTile(
            title: 'Personal Information',
            icon: Icon(Icons.account_circle_rounded),
            route: '/personal-information',
            id: '01',
          ),
          const SettingsListTile(
            title: 'Payment method',
            icon: Icon(Icons.credit_card_outlined),
            route: 'ROUTE2',
            id: '02',
          ),
          const SettingsListTile(
            title: 'Scheduled sessions',
            icon: Icon(Icons.subdirectory_arrow_left_outlined),
            route: 'ROUTE3',
            id: '03',
          ),
          const SettingsListTile(
            title: 'Previous sessions',
            icon: Icon(Icons.swap_horizontal_circle_outlined),
            route: '/previous-sessions',
            id: '04',
          ),
          const SettingsListTile(
            title: 'Notifications',
            icon: Icon(Icons.notifications_active),
            route: 'ROUTE5',
            id: '05',
          ),
          ListTile(
            title: Text("Log out"),
            leading: Icon(Icons.logout),
            onTap: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
    );
  }
}



// class SettingsListTile extends StatelessWidget {
//   final String title;
//   final Icon icon;
//   final String route;
//   final String id;

//   const SettingsListTile(
//       {Key? key,
//       required this.title,
//       required this.icon,
//       required this.route,
//       required this.id})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: icon,
//       title: Text(title, style: Theme.of(context).textTheme.bodyText1),
//       trailing: const Icon(Icons.arrow_forward_ios),
//       onTap: () {
//         Navigator.of(context).pushNamed(route, arguments: id);
//       },
//     );
//   }
// }
