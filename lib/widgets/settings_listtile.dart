import 'package:flutter/material.dart';
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

  @override
  void initState() {
    fetchUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                (widget.title == 'Change Password')
            ? null
            : IconButton(
                onPressed: () {
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
                                              return "please enter your phone number";
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
        .updateField(userID, widget.fireBaseName, input)
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
}
