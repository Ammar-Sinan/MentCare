import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/dr_card_provider.dart';

import './screens/tabs_screen.dart';
import './screens/user_account_screen.dart';
import './screens/doctors_detail_screen.dart';
import 'screens/personal_information_screen.dart';
import './screens/previous_sessions_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => DoctorsDataProvider(),
      child: MaterialApp(
        title: 'MentCare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(22, 92, 144, 1.0),
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            shadowColor: Color.fromRGBO(175, 175, 175, 0.14901960784313725),
            iconTheme: IconThemeData(
              color: Color.fromRGBO(0, 31, 54, 1.0),
            ),
            titleTextStyle: TextStyle(
              color: Color.fromRGBO(0, 31, 54, 100),
              fontFamily: 'Poppins',
              fontSize: 24.2,
              //fontFamily: 'Poppins-Medium',
              // fontFamily: 'assets/fonts/Poppins-Medium.ttf',
            ),
          ),
          fontFamily: 'Poppins',
          textTheme: const TextTheme(
            bodyText1: TextStyle(
                color: Color.fromRGBO(0, 31, 54, 1.0),
                fontSize: 16,
                fontWeight: FontWeight.normal),
            bodyText2: TextStyle(
                color: Color.fromRGBO(0, 31, 54, 1),
                fontSize: 19.22,
                fontWeight: FontWeight.w500),
            subtitle1:
                TextStyle(color: Color.fromRGBO(0, 31, 54, 1), fontSize: 13.3),
          ),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color.fromRGBO(0, 31, 54, 1.0)),
        ),
        //home: TabsScreen(),
        initialRoute: '/',
        routes: {
          '/': (ctx) => const TabsScreen(),
          UserAccountScreen.routeName: (ctx) => const UserAccountScreen(),
          PersonalInformation.routeName: (ctx) => const PersonalInformation(),
          DoctorDetails.routeName: (ctx) => DoctorDetails(),
          PreviousSessions.routeName: (ctx) => PreviousSessions(),
        },
      ),
    );
  }
}

// ThemeData.light().textTheme.copyWith(
// bodyText1: const TextStyle(
// color: Color.fromRGBO(0, 31, 54, 100), fontSize: 13.33),
// bodyText2: const TextStyle(
// color: Color.fromRGBO(0, 31, 54, 100), fontSize: 16)),
