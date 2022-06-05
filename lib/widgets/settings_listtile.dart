import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mentcare/providers/doctors_provider.dart';
import 'package:mentcare/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SettingsListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String fireBaseName;
  final Icon icon;

  const SettingsListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.fireBaseName,
  }) : super(key: key);

  @override
  State createState() {
    return SettingsListTileState();
  }
}

class SettingsListTileState extends State<SettingsListTile> {
  String userID = '';
  String input = '';
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isDoctor = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    fetchUserID();
    fetch();
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

    var doctor;
    List specialityList = [];
    String specText = '';
    DateTime selectedTime = DateTime.now();

    return ListTile(
        leading: widget.icon,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          widget.subtitle,
          style: const TextStyle(fontSize: 13.3),
        ),
        trailing: (widget.title == 'Email') |
                (widget.title == 'Change Password') |
                (widget.title == "Gender")
            ? null
            : IconButton(
                onPressed: () async {
                  doctor = await Provider.of<DoctorsDataProvider>(context,
                          listen: false)
                      .fetchDoctorData();
                  if (widget.title == 'Date Of Birth') {
                    final DateTime? selected = await showDatePicker(
                      initialDate: selectedTime,
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      context: context,
                    );

                    if (selected != null && selected != selectedTime) {
                      String time = DateFormat.yMd().format(selected);
                      print(time);
                      FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(doctor['id'])
                          .update({'dateOfBirth': time});
                    }
                  } else if (widget.title == 'speciality') {
                    doctor = await Provider.of<DoctorsDataProvider>(context,
                            listen: false)
                        .fetchDoctorData();
                    specialityList = doctor['specialisedIn'];

                    showDialog(
                      context: context,
                      builder: (cnt) => Dialog(
                        child: Container(
                          child: StatefulBuilder(
                            builder: (context, setState) => Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            hintText: 'add a speciality...'),
                                        controller: _controller,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          final add = [];
                                          add.add(_controller.text);
                                          FirebaseFirestore.instance
                                              .collection('doctors')
                                              .doc(doctor['id'])
                                              .update({
                                            'specialisedIn':
                                                FieldValue.arrayUnion(add)
                                          });
                                          setState(() {
                                            specialityList
                                                .add(_controller.text);
                                          });
                                          _controller.clear();
                                        },
                                        icon: const Icon(Icons.add))
                                  ],
                                ),
                                Expanded(
                                    child: ListView.builder(
                                  itemBuilder: (cnt, index) {
                                    return Row(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: TextField(
                                            decoration: InputDecoration(
                                                hintText:
                                                    specialityList[index]),
                                            onChanged: (value) =>
                                                specText = value,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              final deleted = [];
                                              deleted
                                                  .add(specialityList[index]);
                                              final add = [];
                                              add.add(specText);

                                              FirebaseFirestore.instance
                                                  .collection('doctors')
                                                  .doc(doctor['id'])
                                                  .update({
                                                'specialisedIn':
                                                    FieldValue.arrayRemove(
                                                        deleted)
                                              });

                                              FirebaseFirestore.instance
                                                  .collection('doctors')
                                                  .doc(doctor['id'])
                                                  .update({
                                                'specialisedIn':
                                                    FieldValue.arrayUnion(add)
                                              });
                                            },
                                            icon: const Icon(Icons.save)),
                                        IconButton(
                                            onPressed: () {
                                              final deleted = [];
                                              deleted
                                                  .add(specialityList[index]);
                                              FirebaseFirestore.instance
                                                  .collection('doctors')
                                                  .doc(doctor['id'])
                                                  .update({
                                                'specialisedIn':
                                                    FieldValue.arrayRemove(
                                                        deleted)
                                              });
                                              setState(() {
                                                specialityList.removeAt(index);
                                              });
                                            },
                                            icon: Icon(Icons.delete))
                                      ],
                                    );
                                  },
                                  itemCount: specialityList.length,
                                ))
                              ],
                            ),
                          ),
                          padding: EdgeInsets.all(20.h),
                        ),
                        
                      ),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (cnt) => Dialog(
                                child: Container(
                              child: Column(
                                children: [
                                  Text(widget.title),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: widget.subtitle,
                                          contentPadding: EdgeInsets.all(10.h)),
                                      onSaved: (value) => input = value!,
                                      validator: widget.title == 'Name'
                                          ? (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "please enter your full name";
                                              }
                                              List spitted;
                                              spitted = value.trim().split(' ');
                                              if (spitted.length < 2) {
                                                return 'please enter your full name';
                                              }
                                              return null;
                                            }
                                          : (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "This can't be empty!";
                                              }
                                              if (value.length < 10) {
                                                return "too short!";
                                              }
                                              return null;
                                            },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        _submit();
                                      },
                                      child: const Text('save'))
                                ],
                              ),
                              padding: EdgeInsets.all(20.h),
                            )));
                  }
                },
                icon: const Icon(Icons.edit),
              ),
        onTap: () {
          widget.title == 'Change Password'
              ? {
                  showDialog(
                      context: context,
                      builder: (cnt) => SingleChildScrollView(
                            child: Dialog(
                                child: Container(
                              child: Column(
                                children: [
                                  Text(widget.title),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Form(
                                      key: _passwordFormKey,
                                      child: Column(
                                        children: [
                                          Text(
                                            'enter your current password',
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              hintText: widget.subtitle,
                                              contentPadding:
                                                  EdgeInsets.all(10.w),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              focusColor: Theme.of(context)
                                                  .primaryColor,
                                              prefixIcon: Icon(
                                                Icons.password_outlined,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            obscureText: true,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "please enter your password";
                                              }
                                              if (value.length < 8) {
                                                return "too short!";
                                              }
                                              return null;
                                            },
                                            onSaved: (value) => input = value!,
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          Text(
                                            'enter the new password',
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              hintText: widget.subtitle,
                                              contentPadding:
                                                  EdgeInsets.all(10.w),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              focusColor: Theme.of(context)
                                                  .primaryColor,
                                              prefixIcon: Icon(
                                                Icons.password_outlined,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            obscureText: true,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "please enter your password";
                                              }
                                              if (value.length < 8) {
                                                return "too short!";
                                              }
                                              return null;
                                            },
                                            onSaved: (value) =>
                                                password = value!,
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  ElevatedButton(
                                      onPressed: () => _changePassword(),
                                      child: const Text('save'))
                                ],
                              ),
                              padding: EdgeInsets.all(15),
                            )),
                          ))
                }
              : null;
        });
  }

  void fetchUserID() async {
    userID =
        await Provider.of<UserProvider>(context, listen: false).fetchUserId();
  }

  void _submit() async {
    bool valid = _formKey.currentState!.validate();

    if (!valid) {
      return;
    }

    _formKey.currentState!.save();
    await Provider.of<UserProvider>(context, listen: false)
        .updateField(
            userID, widget.fireBaseName, input, isDoctor ? 'doctors' : 'users')
        .then((value) => Navigator.of(context).pop());
  }

  void _changePassword() async {
    bool valid = _passwordFormKey.currentState!.validate();

    if (!valid) {
      return;
    }
    _passwordFormKey.currentState!.save();

    await Provider.of<UserProvider>(context, listen: false)
        .changePassword(input, password)
        .then((value) => Navigator.of(context).pop());
  }

  void fetch() async {
    setState(() {
      isLoading = true;
    });
    final uid =
        await Provider.of<UserProvider>(context, listen: false).fetchUserId();
    final df =
        await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
    if (df.exists) {
      isDoctor = true;
    } else {
      isDoctor = false;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
