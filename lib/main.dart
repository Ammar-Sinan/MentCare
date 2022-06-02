import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mentcare/providers/user_provider.dart';
import 'package:mentcare/screens/add_card_screen.dart';
import 'package:mentcare/screens/auth_screen.dart';
import 'package:mentcare/screens/card_auth.dart';
import 'package:mentcare/screens/doctor_personal_information_screen.dart';
import 'package:mentcare/screens/pre_auth_screen.dart';
import 'package:provider/provider.dart';

import './providers/doctors_provider.dart';
import './providers/login_prov.dart';
import './screens/booking_screen.dart';
import './screens/doctors_detail_screen.dart';
import './screens/personal_information_screen.dart';
import './screens/previous_sessions_screen.dart';
import './screens/tabs_screen.dart';
import './screens/user_account_screen.dart';
import './screens/scheduled_session_screen.dart';
import './screens/doctor_dashboard.dart';
import './screens/doctor_tabs_screen.dart';
import './screens/add_appointment_screen.dart';
import './screens/doctor_all_sessions_screen.dart';
import 'providers/login_prov.dart';
import 'screens/personal_information_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (_) => LoginProv(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (BuildContext context) => UserProvider(),
        ),
        ChangeNotifierProvider<DoctorsDataProvider>(
          create: (BuildContext context) => DoctorsDataProvider(),
        )
      ],
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
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (con, snapshot) {
            if (snapshot.hasData) {
              return const AuthScreen();
            } else {
              return const PreAuthScreen();
            }
          },
        ),
        //initialRoute: '/doctor-tabs',
        routes: {
          TabsScreen.routeName: (ctx) => const TabsScreen(),
          UserAccountScreen.routeName: (ctx) => const UserAccountScreen(),
          PersonalInformation.routeName: (ctx) => const PersonalInformation(),
          DoctorDetails.routeName: (ctx) => DoctorDetails(),
          PreviousSessions.routeName: (ctx) => PreviousSessions(),
          AuthScreen.routeName: (cnt) => const AuthScreen(),
          PreAuthScreen.routeName: (cnt) => const PreAuthScreen(),
          AddCard.routeName: (c) => const AddCard(),
          CardAuth.routeName: (c) => const CardAuth(),
          DoctorPersonalInformation.routeName: (c) =>
              const DoctorPersonalInformation(),
          BookingScreen.routeName: (ctx) => BookingScreen(),
          ScheduledSessionsScreen.routeName: (ctx) => ScheduledSessionsScreen(),
          DoctorDashboard.routeName: (ctx) => DoctorDashboard(),
          DrTabsScreen.routeName: (ctx) => const DrTabsScreen(),
          AddAppointment.routeName: (ctx) => const AddAppointment(),
          DoctorAllSessions.routeName: (ctx) => const DoctorAllSessions(),
        },
      ),
    );
  }
}
