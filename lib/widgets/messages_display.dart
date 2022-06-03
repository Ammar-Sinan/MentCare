import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagesDisplay extends StatefulWidget {
  const MessagesDisplay(this.chatId,this.isTheUSerDoctor, {Key? key}) : super(key: key);
  final chatId;
  final isTheUSerDoctor;

  @override
  _MessagesDisplayState createState() => _MessagesDisplayState();
}

class _MessagesDisplayState extends State<MessagesDisplay> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        builder: (cnt, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                reverse: true,
                itemBuilder: (cnt, index) {
                  var t = snapshot.data!.docs[index]['sentAt'] as Timestamp;
                  bool isDoctor = snapshot.data!.docs[index]['isDoctor'];

                  String time = DateFormat('h:mm').format(t.toDate());
                  return widget.isTheUSerDoctor
                      ? Align(
                          child: messageText(
                            time: time,
                            snapshot: snapshot,
                            index: index,
                          ),
                          alignment: isDoctor
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                        )
                      : Align(
                          child: messageText(
                            time: time,
                            snapshot: snapshot,
                            index: index,
                          ),
                          alignment: isDoctor
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                        );
                },
                itemCount: snapshot.data!.docs.length,
              );
            } else {
              return const Center(child: CircularProgressIndicator(),);
            }
          }
        },
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatId)
            .collection('messages')
            .orderBy('sentAt', descending: true)
            .snapshots());
  }
}

class messageText extends StatelessWidget {
  const messageText(
      {Key? key, required this.time, required this.snapshot, this.index})
      : super(key: key);

  final String time;
  final snapshot;
  final index;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 100,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Text(snapshot.data!.docs[index]['text']),
            FittedBox(child: Text(time, style: TextStyle(fontSize: 10)))
          ],
        ));
  }
}
