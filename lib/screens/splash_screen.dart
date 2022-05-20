import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          child: TextButton(onPressed: () {}, child: const Text('skip')),
          alignment: Alignment.centerRight,
        ),
      ],
    );
  }
}
