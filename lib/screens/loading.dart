import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentcare/screens/tabs_screen.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/doctor_tabs_screen.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool isLoading = false;
  late bool isExist;

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : isExist
            ? const DrTabsScreen()
            : const TabsScreen();
  }

  void fetch() async {
    setState(() {
      isLoading = true;
    });
    final uid =
        await Provider.of<UserProvider>(context, listen: false).fetchUserId();
    final df =
        await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
    if (df.exists) {
      isExist = true;
    } else {
      isExist = false;
    }
    setState(() {
      isLoading = false;
    });
  }
}
