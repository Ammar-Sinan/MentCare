import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryChips extends StatelessWidget {
  CategoryChips(this._setFilter, this._setIsFilter, {Key? key}) : super(key: key);
  final Function _setFilter;
  final Function _setIsFilter;

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
              onPressed: () {
                if (category == "Show all") {
                  _setIsFilter(false);
                } else {
                  _setFilter(category.toLowerCase());
                  _setIsFilter(true);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}