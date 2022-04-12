import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  final String title;
  final Icon icon;
  final String route;
  final String id;

  const SettingsListTile(
      {Key? key,
      required this.title,
      required this.icon,
      required this.route,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title, style: Theme.of(context).textTheme.bodyText1),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.of(context).pushNamed(route, arguments: id);
      },
    );
  }
}
