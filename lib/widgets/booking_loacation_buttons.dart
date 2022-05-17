import 'package:flutter/material.dart';

import '../widgets/sessions_buttons_grid.dart';

/// Building the Book and Location Buttons in Dr. Details Screen
class Buttons extends StatelessWidget {
  const Buttons({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String? title;
  final Icon? icon;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            /// On Tap Routes.
            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  content: const Text('Do you want to book a session ?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: 450,
                              child: ListView(
                                children: [
                                  SessionsButtonsGrid(),
                                ],
                              ),
                            );

                            /// Show the user the avaliable dates
                          },
                        );
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: CircleAvatar(
            backgroundColor: const Color.fromRGBO(22, 92, 144, 1.0),
            maxRadius: 24,
            child: icon,
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
