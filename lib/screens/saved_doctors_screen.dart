import 'package:flutter/material.dart';

class SavedDoctorsScreen extends StatelessWidget {
  const SavedDoctorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved specialists'),
      ),
      body: const Center(),

      /// fetch the saved dr cards here - ez task
    );
  }
}
