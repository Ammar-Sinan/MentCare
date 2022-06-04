import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/doctor_model.dart';
import '../screens/doctors_detail_screen.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctorInfo = Provider.of<DoctorData>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(DoctorDetails.routeName, arguments: doctorInfo.id);
      },
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 186.w,
                height: 32.h,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 250, 250, 250),
                ),
              ),
              Container(
                width: 186.w,
                height: 200.h,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(212, 229, 241, 0.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    FittedBox(child: Text(
                      doctorInfo.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText2,),
                    ),
                    Text(doctorInfo.category,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1),
                    SizedBox(height: 8.h),
                    Text(
                      '${doctorInfo.price} JOD',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 55, 86, 113),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Book Now',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            primary: Theme
                                .of(context)
                                .primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              left: 55.w,
              top: 0,
              child:
              FutureBuilder(builder: (cnt, AsyncSnapshot snapshot) {
                if (!snapshot.hasData || snapshot.hasError)
                  {
                    return CircularProgressIndicator();
                  }
                else
                return CircleAvatar(
                  radius: 32.r,
                  backgroundImage: NetworkImage(snapshot.data!['profileImageUrl']),
                  backgroundColor: Colors.blue,
                );
              }, future: FirebaseFirestore.instance.collection("doctors").doc(doctorInfo.id).get(),)
          ),
        ],
      ),
    );
  }
}
