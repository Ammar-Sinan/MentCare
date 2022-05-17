import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Messages',
            style: TextStyle(
              color: Color.fromRGBO(0, 31, 54, 1.0),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_active_outlined),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) => const ListTile(
          leading: CircleAvatar(
            maxRadius: 24,
          ),
          contentPadding: EdgeInsets.all(8),
          title: Text(
            'Sender name',
            style: TextStyle(fontSize: 16),
          ),
          trailing: Text(
            '2:54 pm',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
