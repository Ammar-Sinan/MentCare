import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/doctors_provider.dart';

import '../widgets/dr_card_home.dart';

class SavedDoctorsScreen extends StatefulWidget {
  const SavedDoctorsScreen({Key? key}) : super(key: key);

  @override
  State<SavedDoctorsScreen> createState() => _SavedDoctorsScreenState();
}

class _SavedDoctorsScreenState extends State<SavedDoctorsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final savedList =
        Provider.of<DoctorsDataProvider>(context, listen: false).savedList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved specialists'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator() )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: savedList.length,
                itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                  value: savedList[index],
                  child: const DoctorCard(),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 2,
                  mainAxisExtent: 240,
                ),
              ),
            ),
    );
  }
  void fetch ()async
  {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<DoctorsDataProvider>(context, listen: false).fetchUserSaved();
    setState(() {
      _isLoading = false;
    });
  }
}
