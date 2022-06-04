import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MessagesDisplay extends StatefulWidget {
  const MessagesDisplay(this.chatId, {Key? key})
      : super(key: key);
  final chatId;


  @override
  _MessagesDisplayState createState() => _MessagesDisplayState();
}

class _MessagesDisplayState extends State<MessagesDisplay> {

  bool? isTheSenderDoctor=null;


  @override
  void initState() {
    fetchIsDoctor();
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
                  return isTheSenderDoctor==null ? CircularProgressIndicator():
                      isTheSenderDoctor! ? Align(
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
              return const Center(
                child: CircularProgressIndicator(),
              );
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

  void fetchIsDoctor() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final df =
    await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
    if (df.exists) {
      isTheSenderDoctor = true;
    } else {
      isTheSenderDoctor = false;
    }
    setState(() {

    });
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
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 30.h, minWidth: 100, maxHeight: 70.h),
      child: Container(
          margin: const EdgeInsets.all(5),
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(20)),
          child:
             FittedBox(child: Column(
              children: [
                Text(snapshot.data!.docs[index]['text']),
                Text(time, style: TextStyle(fontSize: 10.sp))
              ],
            ),),
          ),
    );
  }
}
