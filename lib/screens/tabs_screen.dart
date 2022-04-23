import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './user_account_screen.dart';
import './home_screen.dart';
import './saved_doctors_screen.dart';
import './messages.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);
  static const routeName = '/tabs';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': HomeScreen(),
      },
      {
        'page': const SavedDoctorsScreen(),
      },
      {
        'page': const MessagesScreen(),
      },
      {
        'page': const UserAccountScreen(),
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(
      () {
        _selectedPageIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    ScreenUtil.init(
        BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height,
        ),
        designSize: Size(width, height),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: const Color.fromRGBO(255, 255, 255, 0.5),
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            label: 'Saved',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.message_rounded),
            label: 'Messages',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: 'Account',
            backgroundColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
