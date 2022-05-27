import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/booked_sessions.dart';

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
                      onTap:
                          () {}, // get the patient id easily and navigate to PM
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
                                    '- Phone number : ${bookedSession.phoneNum}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                      '- Time ${formatter.format(bookedSession.time)}'),
                                  Text(
                                    '- Detils provided by the user\n ${bookedSession.details}',
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
}
