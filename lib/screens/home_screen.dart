import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/doctors_provider.dart';
import '../widgets/category_chips.dart';
import '../widgets/dr_card_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = 'homeScreen';

  @override
  State createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool _isFiltered = false;
  String _filter = '';

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
    final drCard = _isFiltered ? drData.showCategory(_filter) : drData.cardInfo;
    final TextEditingController _nameController = TextEditingController();

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(top: 8.h, bottom: 16.h, left: 16.w, right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FittedBox(
              child: Row(
                children: [
                  Text(
                    'Need someone to talk to?',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 16),
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
              'We have more than 300 registered\ntherapist to help',
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
                      onSubmitted: (_) {
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
            CategoryChips(_setFilter, _setIsFilter),
            Expanded(
              child: _isLoading
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

  void _setFilter(cat) {
    setState(() {
      _filter = cat;
    });
  }

  void _setIsFilter(isF) {
    setState(() {
      _isFiltered = isF;
    });
  }

  void _fetchData() {
    setState(() {
      _isLoading = true;
      Provider.of<DoctorsDataProvider>(context, listen: false)
          .fetchDoctorsList()
          .then((value) {
        _isLoading = false;
      });
    });
  }
}
