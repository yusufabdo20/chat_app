import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:chat_app/components.dart';
import 'package:chat_app/models/messageModel.dart';

import '../constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class ChatScreen extends StatelessWidget {
  static String id = 'chat_screen';
  final ScrollController _controller = ScrollController();

  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);
  var msgController = TextEditingController();
  void _scrollDown() {
    _controller.animateTo(
      // _controller.position.minScrollExtent,
      0,
      duration: Duration(seconds: 2),

      curve: Curves.easeIn,
    );
  }

// void _scrollDown() {
//   _controller.jumpTo(_controller.position.maxScrollExtent);
// }
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    //  return FutureBuilder<QuerySnapshot>(
    return StreamBuilder<QuerySnapshot>(
      // future: messages.get(),
      stream: messages.orderBy("createdAt", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> msgsList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            msgsList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              automaticallyImplyLeading: false,
              title:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image(
                  image: AssetImage(kLogo),
                  width: 50,
                  height: 50,
                ),
                buildTextPacificoNormal(
                    text: "Chat", textSize: 22, textColor: Colors.white)
              ]),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return msgsList[index].id == email
                          ? bubble1(
                              msg: msgsList[index],
                            )
                          : bubble2(msg: msgsList[index]);
                    },
                    itemCount: msgsList.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: msgController,
                    onSubmitted: (value) {
                      _scrollDown();
                      msgController.text = value;
                      messages.add({
                        'msg': value,
                        'createdAt': DateTime.now(),
                        'id': email,
                      });
                      msgController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "Send messages to user",
                      suffixIcon: Icon(
                        Icons.send,
                        color: kPrimaryColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: kPrimaryColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: kPrimaryColor, width: 2.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          print("NO data ya man");
          return Scaffold(
            body: Container(
              color: kPrimaryColor,
              child: Center(
                child: buildTextPacificoNormal(
                    text: "LOADING >>>>  ",
                    textSize: 30,
                    textColor: Colors.white),
              ),
            ),
          );
        }
      },
    );
  }
}

class bubble1 extends StatelessWidget {
  final MessageModel msg;
  const bubble1({
    Key? key,
    required this.msg,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        //  width: 150,
        child: Text(
          msg.msg,

          style: TextStyle(color: Colors.white),
          // textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
      ),
    );
  }
}

class bubble2 extends StatelessWidget {
  final MessageModel msg;
  const bubble2({
    Key? key,
    required this.msg,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        //  width: 150,
        child: Text(
          msg.msg,

          style: TextStyle(color: Colors.white),
          // textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
      ),
    );
  }
}
