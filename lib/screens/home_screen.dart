import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/dr_card_home.dart';
import '../providers/dr_card_provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drData = Provider.of<DoctorsDataProvider>(context);
    final drCard = drData.cardInfo;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Need someone to talk to?',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_active_outlined),
                )
              ],
            ),
            Text(
              'We have more than 300 registered therapist to help',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              height: 40.h,
              child: TextField(
                decoration: InputDecoration(
                  //enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.all(6),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  fillColor: const Color.fromRGBO(242, 242, 242, 1.0),
                  filled: true,
                  hintText: 'search therapist name or category',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            CategoryChips(),

            /// Widget is below
            SingleChildScrollView(
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: drCard.length,
                itemBuilder: (BuildContext c, int i) =>
                    ChangeNotifierProvider.value(
                  value: drCard[i],
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
          ],
        ),
      ),
    );
  }
}

class CategoryChips extends StatelessWidget {
  CategoryChips({Key? key}) : super(key: key);

  final List<String> categories = [
    'Show all',
    'Behavioral',
    'Addiction',
    'Cognitive',
    'Couples',
    'Family counselor'
  ]; // maybe use map in the list <MAP<STRING STRING>> with id to show the chosen chip

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Container(
            margin: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.5.w)),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 13.3,
                  color: Color.fromRGBO(22, 99, 144, 1),
                ),
              ),
              onPressed: () {},
            ),
          );
        }).toList(),
      ),
    );
  }
}
