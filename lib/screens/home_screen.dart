import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/doctors_provider.dart';
import '../widgets/dr_card_home.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  bool isFiltered = false;
  String filter = '';

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

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

    final drData = Provider.of<DoctorsDataProvider>(context);
    final drCard = isFiltered ? drData.showCategory(filter) : drData.cardInfo;
    final TextEditingController _nameController = TextEditingController();

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(top: 8.h, bottom: 16.h, left: 16.w, right: 16.w),
        child: Column(
          children: [
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Need someone to talk to?',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_active_outlined,
                    ),
                  )
                ],
              ),
            ),
            Text(
              'We have more than 300 registered therapist to help',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              height: 40.h,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        //enabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(6),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: const Color.fromRGBO(242, 242, 242, 1.0),
                        filled: true,
                        hintText: 'search therapist name',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      controller: _nameController,
                      onSubmitted: (_) async {
                        drData.searchByDoctorName(_nameController.text);
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () => _fetchData(),
                      icon: const Icon(Icons.cancel))
                ],
              ),
            ),
            CategoryChips(setFilter, setIsFilter),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: drCard.length,
                      itemBuilder: (BuildContext c, int i) =>
                          ChangeNotifierProvider.value(
                        value: drCard[i],
                        child: const DoctorCard(),
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 3 / 2,
                        mainAxisExtent: 240,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void setFilter(cat) {
    setState(() {
      filter = cat;
    });
  }

  void setIsFilter(isF) {
    setState(() {
      isFiltered = isF;
    });
  }

  void _fetchData() {
    setState(() {
      isLoading = true;
      Provider.of<DoctorsDataProvider>(context, listen: false)
          .fetchDoctorsList()
          .then((value) {
        isLoading = false;
      });
    });
  }
}

class CategoryChips extends StatelessWidget {
  CategoryChips(this.setFilter, this.setIsFilter, {Key? key}) : super(key: key);
  Function setFilter;
  Function setIsFilter;

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
              onPressed: () {
                if (category == "Show all") {
                  setIsFilter(false);
                } else {
                  setFilter(category.toLowerCase());
                  setIsFilter(true);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
