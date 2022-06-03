import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                            child: StatefulBuilder(
                                builder: (context, setState) => Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 150,
                                              child: TextField(
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        'add a speciality...'),
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
                                                        FieldValue.arrayUnion(
                                                            add)
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
                                                  width: 100,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            specialityList[
                                                                index]),
                                                    onChanged: (value) =>
                                                        specText = value,
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      final deleted = [];
                                                      deleted.add(
                                                          specialityList[
                                                              index]);
                                                      final add = [];
                                                      add.add(specText);

                                                      FirebaseFirestore.instance
                                                          .collection('doctors')
                                                          .doc(doctor['id'])
                                                          .update({
                                                        'specialisedIn':
                                                            FieldValue
                                                                .arrayRemove(
                                                                    deleted)
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection('doctors')
                                                          .doc(doctor['id'])
                                                          .update({
                                                        'specialisedIn':
                                                            FieldValue
                                                                .arrayUnion(add)
                                                      });
                                                    },
                                                    icon:
                                                        const Icon(Icons.save)),
                                                IconButton(
                                                    onPressed: () {
                                                      final deleted = [];
                                                      deleted.add(
                                                          specialityList[
                                                              index]);
                                                      FirebaseFirestore.instance
                                                          .collection('doctors')
                                                          .doc(doctor['id'])
                                                          .update({
                                                        'specialisedIn':
                                                            FieldValue
                                                                .arrayRemove(
                                                                    deleted)
                                                      });
                                                      setState(() {
                                                        specialityList
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    icon: Icon(Icons.delete))
                                              ],
                                            );
                                          },
                                          itemCount: specialityList.length,
                                        ))
                                      ],
                                    ))));
                  } else {
                    showDialog(
                        context: context,
                        builder: (cnt) => Dialog(
                                child: Column(
                              children: [
                                Text(widget.title),
                                Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: widget.subtitle),
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
                                    )),
                                ElevatedButton(
                                    onPressed: () async {
                                      _submit();
                                    },
                                    child: const Text('save'))
                              ],
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
                                child: Column(
                              children: [
                                Text(widget.title),
                                Form(
                                    key: _passwordFormKey,
                                    child: Column(
                                      children: [
                                        const Text(
                                            'enter your current password'),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              hintText: widget.subtitle),
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
                                        const Text('enter the new password'),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              hintText: widget.subtitle),
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
                                          onSaved: (value) => password = value!,
                                        )
                                      ],
                                    )),
                                ElevatedButton(
                                    onPressed: () => _changePassword(),
                                    child: const Text('save'))
                              ],
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
