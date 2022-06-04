import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mentcare/screens/booking_screen.dart';
import 'package:provider/provider.dart';

import '../providers/doctors_provider.dart';

class SessionsButtonsGrid extends StatefulWidget {
  String drId;
  String price;
  String name;

  SessionsButtonsGrid(
      {required this.drId, required this.price, required this.name});

  @override
  State<SessionsButtonsGrid> createState() => _SessionsButtonsGridState();
}

class _SessionsButtonsGridState extends State<SessionsButtonsGrid> {
  final DateFormat formatter = DateFormat('dd/MM, hh:mm');
  bool isSessionsEmpty = false;
  bool isLoading = false;

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  void initState() {
    fetchSessions();
    super.initState();
  }

  Future<void> fetchSessions() async {
    await Provider.of<DoctorsDataProvider>(context, listen: false)
        .fetchSessions(widget.drId);
    //fetch();
  }

  /// Send the session data you get from here to the Booking.dart screen
  /// And use it there in the form to save the session
  void fetch() async {
    await Provider.of<DoctorsDataProvider>(context, listen: false)
        .fetchSessions(widget.drId);
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

    final sessionsDates =
        Provider.of<DoctorsDataProvider>(context, listen: false).sessions;

    return isSessionsEmpty
        ? const Center(
            child: Text('No avaliable appointments'),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sessionsDates.length,
            itemBuilder: (ctx, index) {
              return SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(255, 224, 178, 0.75),
                    shadowColor: const Color.fromRGBO(171, 130, 8, 0.20),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(BookingScreen.routeName, arguments: [
                      sessionsDates[index].dateAndTime,
                      sessionsDates[index].id,
                      widget.drId,
                      widget.price,
                      widget.name
                    ]);
                  },
                  child: FittedBox(
                    fit: BoxFit.contain,

                    /// Session Text
                    child: Text(
                      formatter.format(sessionsDates[index].dateAndTime),
                      style: const TextStyle(
                        color: Color.fromRGBO(105, 65, 3, 1),
                      ),
                    ),
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              mainAxisExtent: 56,
            ),
          );
  }
}
