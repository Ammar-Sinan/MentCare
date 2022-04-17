import 'package:flutter/material.dart';
import 'package:mentcare/providers/dr_card_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../dummy_data/doctor_card_data.dart';
import '../screens/doctors_detail_screen.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final labels = Provider.of<DoctorData>(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(DoctorDetails.routeName, arguments: labels.id);
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
                    SizedBox(
                      height: 48.h,
                    ),
                    Text(
                      labels.name,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(labels.category,
                        style: Theme.of(context).textTheme.bodyText1),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(labels.price),
                    SizedBox(
                      height: 8.h,
                    ),
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
                            primary: Theme.of(context).primaryColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 55.w,
            top: 0,
            child: const CircleAvatar(
              radius: 32,
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
