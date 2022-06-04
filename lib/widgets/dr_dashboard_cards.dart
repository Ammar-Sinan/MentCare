import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/booked_sessions.dart';
import '../screens/chatting_screen.dart';

class BuildDashboardCard extends StatelessWidget {
  // Receiving index for the ternary expression for Card Color
  int index;

  BuildDashboardCard({required this.index});

  final DateFormat formatter = DateFormat('MM-dd, hh:mm a');

  @override
  Widget build(BuildContext context) {
    final bookedSession = Provider.of<BookedSessions>(context);
    Color textColor =
        index % 2 == 0 ? Colors.white : const Color.fromARGB(255, 1, 52, 110);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(width, height),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: index % 2 == 0
          ? const Color.fromRGBO(22, 92, 144, 1.0)
          : const Color.fromRGBO(128, 187, 255, .7),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'name : ${bookedSession.userName}',
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                  ),
                ),
                PopupMenuButton(
                  child: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('contact patient'),
                      onTap: () {
                        goToChatScreen(bookedSession.userId,
                            bookedSession.userName, context);
                      }, // get the patient id easily and navigate to PM
                    ),
                    PopupMenuItem(
                      child: const Text('details'),
                      onTap: () async {
                        await Future.delayed(const Duration(seconds: 0));
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              scrollable: true,
                              title: const Text(
                                'Session details :',
                                style: TextStyle(
                                  color: Color(0xFF757575),
                                ),
                              ),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '* Phone number : ${bookedSession.phoneNum}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                      '* Time ${formatter.format(bookedSession.time)}'),
                                  Text(
                                    '* Detils provided by the user\n ${bookedSession.details}',
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context).primaryColor)),
                                  child: const Text('Back'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'location : ${bookedSession.isOnline ? 'Online' : 'Clininc'}',
              style: TextStyle(color: textColor, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              formatter.format(bookedSession.time),
              style: TextStyle(color: textColor, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  void goToChatScreen(String userId, String userName, BuildContext con) async {
    String doctorId = FirebaseAuth.instance.currentUser!.uid;

    final chatId =
        userId.substring(0, 10) + doctorId.toString().substring(10, 20);

    final cList = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('contactList')
        .doc(doctorId);
    final contact = await cList.get();

    if (!contact.exists) {
      await cList.set(
        {
          'doctorId': doctorId,
          'chatId': chatId,
          //'doctorName': doctorName
        },
      );
    }
    final uList = FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('contactList')
        .doc(userId);
    final userContact = await uList.get();

    if (!userContact.exists) {
      await uList.set(
        {
          'userId': userId,
          'chatId': chatId,
          // 'userName': userName
        },
      );
    }
    List IDs = [userName, chatId];
    Navigator.pushNamed(con, ChattingScreen.routeName, arguments: IDs);
  }
}
