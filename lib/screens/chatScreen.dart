import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FocusNode textNode = FocusNode();
  TextEditingController _chat = TextEditingController();
  sendMsg() async {}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(),
            backgroundColor: Colors.grey,
            body: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black)),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.face,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              textNode.unfocus();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.attach_file,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              textNode.unfocus();
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _chat,
                              focusNode: textNode,
                              // onTap: () =>
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter the message...",
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          // ignore: unnecessary_statements
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                                backgroundColor: Color(0xff5a8cf4),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    print("send");

                                    _chat.text.length > 0
                                        ? await sendMsg()
                                        : null;
                                    textNode.unfocus();
                                  },
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ]))));
  }
}
