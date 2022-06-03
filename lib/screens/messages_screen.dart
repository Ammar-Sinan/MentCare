import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentcare/screens/chatting_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

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
      body: StreamBuilder(
        builder: (cnt, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child:
                          ListTile(
                            leading: CircleAvatar(),
                            title: Text(
                              snapshot.data!.docs[index]['doctorName'],
                              style: TextStyle(fontSize: 16),
                            ),
                          )

                    ),
                    onTap: () {
                      List IDs = [
                        snapshot.data!.docs[index]['doctorName'],
                        snapshot.data!.docs[index]['chatId']
                      ];
                      Navigator.of(context)
                          .pushNamed(ChattingScreen.routeName, arguments: IDs);
                    },
                  );
                });
          }
        },
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('contactList')
            .snapshots(),
      ),
    );
  }
}
