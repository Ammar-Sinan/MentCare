import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingScreen extends StatefulWidget {
  //const BookingScreen({Key? key}) : super(key: key);

  static const routeName = '/booking';

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController details = TextEditingController();
  bool checkOnline = false;
  bool checkClinic = false;

  InputDecoration textFieldDecoration(BuildContext context, String label) {
    return InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(8),
      label: Text(
        label,
        style: const TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 223, 223, 223), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    name = TextEditingController();
    phoneNumber = TextEditingController();
    details = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    phoneNumber.dispose();
    details.dispose();
    super.dispose();
  }

  Row buildCheckBoxes(String label, bool checkBoxValue) {
    return Row(
      children: [
        Text(label),
        Checkbox(
          value: checkBoxValue,
          onChanged: (value) {
            setState(() {
              checkBoxValue = value!;
            });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Getting the session data [id, dateAndTime , locstion] in a list
    var sessionDates = ModalRoute.of(context)!.settings.arguments as List;

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete booking process',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                'session at\n ${sessionDates[0].toString()}',
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: name,
                onChanged: (value) => name.text = value,
                textInputAction: TextInputAction.next,
                decoration: textFieldDecoration(context, 'name'),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: phoneNumber,
                onChanged: (value) => phoneNumber.text = value,
                textInputAction: TextInputAction.next,
                decoration:
                    textFieldDecoration(context, 'phone number - optional'),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: details,
                onChanged: (value) => phoneNumber.text = value,
                textInputAction: TextInputAction.next,
                decoration: textFieldDecoration(context,
                    'Anything you want your therapist\nto know before your next session ?'),
                maxLines: 5,
              ),
              SizedBox(
                height: 16.h,
              ),
              const Text(
                'where do you want\nto have the session :',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              Row(
                children: [
                  const Text('Online'),
                  Checkbox(
                    value: checkOnline,
                    onChanged: (value) {
                      setState(() {
                        checkOnline = value!;
                      });
                    },
                  ),
                  SizedBox(width: 40.w),
                  const Text('Clinic'),
                  Checkbox(
                    value: checkClinic,
                    onChanged: (value) {
                      setState(() {
                        checkClinic = value!;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Add payment method',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColor,
                          fontSize: 16,
                          color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  child: const Text('Finish Booking'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
