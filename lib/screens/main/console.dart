import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:control_button/control_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sws_app/models/message.dart';

class Console extends StatefulWidget {
  const Console({
    @required this.size,
    @required this.messages,
    @required this.sendMessage,
    @required this.textEditingController,
    @required this.listScrollController,
  });
  final Size size;
  final List<Message> messages;
  final Function sendMessage;
  final TextEditingController textEditingController;
  final ScrollController listScrollController;

  @override
  _Console createState() => new _Console();
}

class _Console extends State<Console> {
  final int clientID = 0;

  // final TextEditingController textEditingController =
  //     new TextEditingController();
  // final ScrollController listScrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.sendMessage('!f00');
    super.dispose();
  }

  double _value = 90.0;
  @override
  Widget build(BuildContext context) {
    final List<Row> list = widget.messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color: _message.whom == clientID
                    ? Colors.greenAccent
                    : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: widget.size.height * 0.35),
          Flexible(
            child: ListView(
                padding: const EdgeInsets.all(12.0),
                controller: widget.listScrollController,
                children: list),
          ),
          // Row(
          //   children: <Widget>[
          //     Flexible(
          //       child: Container(
          //         margin: const EdgeInsets.only(left: 16.0),
          //         child: TextField(
          //           style: const TextStyle(
          //               fontSize: 15.0, color: Colors.deepPurpleAccent),
          //           controller: widget.textEditingController,
          //           onChanged: ,
          //           decoration: InputDecoration.collapsed(
          //             hintText: 'Type your message...',
          //             hintStyle: const TextStyle(color: Colors.grey),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Container(
          //       margin: const EdgeInsets.all(8.0),
          //       child: IconButton(
          //           icon: const Icon(Icons.send),
          //           onPressed: () =>
          //               widget.sendMessage(widget.textEditingController.text)),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
