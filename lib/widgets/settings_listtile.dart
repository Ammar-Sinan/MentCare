import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Icon icon;
  final String route;

  /// this class is used for UserAccountScreen() Screen , PersonalInformation() Screen

  const SettingsListTile(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 13.3),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
    );
  }
}
