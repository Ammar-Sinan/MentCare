import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/doctors_provider.dart';
import '../widgets/dr_card_home.dart';

class SavedDoctorsScreen extends StatelessWidget {
  const SavedDoctorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savedList =
        Provider.of<DoctorsDataProvider>(context, listen: false).savedList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved specialists'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        // child: GridView.builder(
        //   itemCount: savedList.length,
        //   itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        //     value: savedList[index],
        //     child: const DoctorCard(),
        //   ),
        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2,
        //     mainAxisSpacing: 16,
        //     crossAxisSpacing: 16,
        //     childAspectRatio: 3 / 2,
        //     mainAxisExtent: 240,
        //   ),
        // ),
      ),
    );
  }
}
