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
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: StreamBuilder(
        builder: (cnt, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                            leading: getProfilePicture(
                                snapshot.data!.docs[index]['doctorId']),
                            title: getUserNameWidget(
                                snapshot.data!.docs[index]['doctorId']))),
                    onTap: () async{
                      final doctorName = await getUserName(snapshot.data!.docs[index]['doctorId']);
                      List IDs = [
                        doctorName,
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

  Widget getProfilePicture(String doctorId) {
    return FutureBuilder(
      builder: (cnt, AsyncSnapshot snapshot) {
        if (snapshot.hasError || !snapshot.hasData)
          return CircularProgressIndicator();
        else if (snapshot.data == '')
          return CircleAvatar(
            radius: 32,
            backgroundColor: Colors.grey,
          );
        else
          return CircleAvatar(
            radius: 32,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(snapshot.data),
          );
      },
      future: getProfilePictureUrl(doctorId),
    );
  }

  Future<String> getProfilePictureUrl(doctorId) async {
    final doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();

    return doctor['profileImageUrl'];
  }

  Future<String> getUserName(doctorId) async {
    final doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();
    return doctor['name'];
  }

  Widget getUserNameWidget(String doctorId) {
    return FutureBuilder(
      builder: (cnt, AsyncSnapshot snapshot) {
        if (snapshot.hasError || !snapshot.hasData)
          return LinearProgressIndicator();
        else
          return Text(snapshot.data);
      },
      future: getUserName(doctorId),
    );
  }
}
