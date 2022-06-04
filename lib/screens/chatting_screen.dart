import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentcare/widgets/messages_display.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({Key? key}) : super(key: key);
  static const String routeName = 'chatting_screen';

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  //bool isLoading = true;
  late final otherUserName;
  late final chatId;
  bool isDoctor = false;
  late final doctor;

  @override
  void didChangeDependencies() {
    fetchIsDoctor();

    List IDs = ModalRoute.of(context)!.settings.arguments as List;

    otherUserName = IDs[0];
    chatId = IDs[1];

    super.didChangeDependencies();
  }

  final TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(otherUserName),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back)),
        actions: [],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
                padding: EdgeInsets.all(10), child: MessagesDisplay(chatId)),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(width: 2, color: Theme.of(context).primaryColor),
              left: BorderSide(width: 2, color: Theme.of(context).primaryColor),
              right:
                  BorderSide(width: 2, color: Theme.of(context).primaryColor),
            )),
            child: Container(
                decoration: BoxDecoration(color: Colors.grey[100]),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _message,
                    )),
                    IconButton(
                        onPressed: () => sentMessage(),
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ))
                  ],
                )),
          )
        ],
      ),
    );
  }

  void sentMessage() async {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': _message.text,
      'isDoctor': isDoctor ? true : false,
      'sentAt': Timestamp.now()
    });
    _message.clear();
  }

  void fetchIsDoctor() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final df =
        await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
    if (df.exists) {
      isDoctor = true;
    } else {
      isDoctor = false;
    }
  }

  @override
  void dispose() {
    _message.clear();
    _message.dispose();
    super.dispose();
  }
}
