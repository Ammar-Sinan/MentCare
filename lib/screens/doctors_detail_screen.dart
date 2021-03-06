import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentcare/providers/user_provider.dart';
import 'package:mentcare/screens/chatting_screen.dart';
import 'package:mentcare/widgets/sessions_buttons_grid.dart';
import 'package:provider/provider.dart';

import '../providers/doctors_provider.dart';
import '../widgets/booking_loacation_buttons.dart';
import '../widgets/reviews_card_dr_detail.dart';

class DoctorDetails extends StatefulWidget {
  static const routeName = '/doctor-detail';

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  Color iconColor = Colors.white;
  bool isSaved = false;
  Icon? saveIcon;
  String doctorName = '';
  String userName = '';

  TextStyle textStyle =
      const TextStyle(fontSize: 19.2, fontWeight: FontWeight.w400);


  @override
  Widget build(BuildContext context) {
    final doctorId = ModalRoute.of(context)!.settings.arguments as String;

    final doctorProvider =
        Provider.of<DoctorsDataProvider>(context, listen: false);
    final doctorData = doctorProvider.findById(doctorId);
    final savedDoctorsIds = doctorProvider.savedDoctorsIds;

    /// Check if Dr ID exist in savedDoctorsIds List to show the suitable Icon
    bool isStored = savedDoctorsIds.contains(doctorId);
    Icon isSaved = Icon(isStored ? Icons.turned_in : Icons.turned_in_not);

    fetchDoctorName(doctorId);
    fetchUserName();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        elevation: 7,
        actions: [
          Builder(builder: (ctx) {
            return IconButton(
              onPressed: () async {
                setState(() {
                  isStored;
                });
                await Provider.of<DoctorsDataProvider>(context, listen: false)
                    .toggleSaveStatus(doctorId);
              },
              icon: isSaved,
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400.h,
                  color: const Color.fromRGBO(212, 229, 241, 1.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 48.w,
                          ),
                          getProfilePicture(doctorId),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5.h),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                String userId =
                                    FirebaseAuth.instance.currentUser!.uid;

                                final chatId = userId.substring(0, 10) +
                                    doctorId.toString().substring(10, 20);

                                final cList = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .collection('contactList')
                                    .doc(doctorId);
                                final contact = await cList.get();


                                if (!contact.exists) {
                                  await cList.set(
                                    {
                                      'doctorId': doctorId,
                                      'chatId': chatId,
                                      'doctorName': doctorName
                                    },
                                  );
                                }
                                final uList = FirebaseFirestore.instance
                                    .collection('doctors')
                                    .doc(doctorId)
                                    .collection('contactList')
                                    .doc(userId);
                                final userContact = await uList.get();

                                if (!userContact.exists) {
                                  await uList.set(
                                    {
                                      'userId': userId,
                                      'chatId': chatId,
                                      'userName': userName
                                    },
                                  );
                                }
                                List IDs = [doctorName, chatId];
                                Navigator.pushReplacementNamed(
                                    context, ChattingScreen.routeName,
                                    arguments: IDs);
                              },
                              icon: const Icon(Icons.message_rounded),
                              color: Theme.of(context).primaryColor,
                              iconSize: 28,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Doctor name
                      Text(
                        doctorData.name,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        doctorData.category,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                        '${doctorData.price}\$/hour',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Buttons(
                              title: 'Book',
                              icon: Icon(Icons.calendar_today_outlined,
                                  color: iconColor),
                              route: '1'),
                          Buttons(
                              title: 'location',
                              icon: Icon(Icons.location_on_outlined,
                                  color: iconColor),
                              route: '2'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 370.h,
              left: 50.w,
              right: 50.w,
              child: SizedBox(
                height: 100.h,
                width: 256.w,
                child: Card(
                  elevation: 8,
                  shadowColor: const Color.fromRGBO(168, 162, 162, 0.15),
                  //color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      ReviewCard(title: 'Reviews', number: '34', id: 420),
                      ReviewCard(title: 'Rating', number: '4.8', id: 420),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w, left: 16.w, bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 480.h,
                  ),
                  Text(
                    'available sessions',
                    style: textStyle,
                  ),
                  BuildSessionDates(
                    id: doctorId,
                    price: doctorData.price,
                    doctorName: doctorData.name,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'specialised in',
                    style: textStyle,
                  ),
                  SizedBox(height: 12.h),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: doctorData.specialisedIn.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        padding: const EdgeInsets.all(4),
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromRGBO(212, 229, 241, 0.2),
                        ),
                        child: Text(doctorData.specialisedIn[index],
                            textAlign: TextAlign.center),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 40.h,
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 12.h,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Education',
                    style: textStyle,
                  ),
                  SizedBox(height: 16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorData.university,
                        style: const TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        doctorData.major,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void fetchDoctorName(doctorId) async {
    doctorName = await Provider.of<DoctorsDataProvider>(context, listen: false)
        .fetchDoctorNameFromUserInterface(doctorId);
  }

  void fetchUserName() async {
    userName =
        await Provider.of<UserProvider>(context, listen: false).fetchUserName();
  }

  Widget getProfilePicture(String doctorId) {
    return FutureBuilder(
      builder: (cnt, AsyncSnapshot snapshot) {
        if (snapshot.hasError || !snapshot.hasData)
          return CircularProgressIndicator();
        else if (snapshot.data == '')
          return CircleAvatar(
            radius: 32,
            backgroundColor: Colors.grey,
          );
        else
          return CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(snapshot.data),
          );
      },
      future: getProfilePictureUrl(doctorId),
    );
  }

  Future<String> getProfilePictureUrl(userId) async {
    final user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(userId)
        .get();

    return user['profileImageUrl'];
  }
}

/// Build / Booking - Location Buttons

class BuildSessionDates extends StatefulWidget {
  //const BuildSessionDates({Key? key}) : super(key: key);
  final String id;
  final String price;
  final String doctorName;
  const BuildSessionDates(
      {required this.id, required this.price, required this.doctorName});

  @override
  State<BuildSessionDates> createState() => _BuildSessionDatesState();
}

class _BuildSessionDatesState extends State<BuildSessionDates> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: const Color(0xFFF4F4F4),
      textColor: const Color(0xFF165C90),
      collapsedBackgroundColor: const Color(0x172696EB),
      iconColor: const Color(0xFF165C90),
      title: const Text(
        'Sessions',
        style: TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_drop_down_circle),
      children: [
        SessionsButtonsGrid(
          drId: widget.id,
          price: widget.price,
          name: widget.doctorName,
        ),
      ],
    );
  }
}
