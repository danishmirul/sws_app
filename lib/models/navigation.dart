import 'package:cloud_firestore/cloud_firestore.dart';

class Navigation {
  String uid;
  String wheelchairID;
  String instruction;
  String console;
  String msg;
  bool request;
  bool execute;
  DateTime createdAt;

  Navigation({
    this.uid,
    this.wheelchairID,
    this.instruction = '',
    this.console = '',
    this.msg = '',
    this.request,
    this.execute,
    createdAt,
  }) {
    if (createdAt == null || createdAt == 0)
      this.createdAt = DateTime.now();
    else
      this.createdAt = createdAt;
  }

  Navigation.copy(Navigation from)
      : this(
          uid: from.uid,
          wheelchairID: from.wheelchairID,
          instruction: from.instruction,
          console: from.console,
          msg: from.msg,
          request: from.request,
          execute: from.execute,
          createdAt: from.createdAt,
        );

  @override
  String toString() =>
      "{ uid:${this.uid}, wheelchairID:${this.wheelchairID}, instruction:${this.instruction}, msg:${this.msg}, request:${this.request} }";

  // initialised through snapshot
  Navigation.fromSnapShot(DocumentSnapshot snapshot) {
    this.uid = snapshot.id;
    // this.uuid = snapshot.data['uuid'];
    this.wheelchairID = snapshot.get(FieldPath(['wheelchairID']));
    this.instruction = snapshot.get(FieldPath(['instruction']));
    this.console = snapshot.get(FieldPath(['console']));
    this.msg = snapshot.get(FieldPath(['msg']));
    this.request = snapshot.get(FieldPath(['request']));
    this.execute = snapshot.get(FieldPath(['execute']));
    this.createdAt = snapshot.get(FieldPath(['createdAt'])).toDate();
  }

  // map to object
  factory Navigation.fromMap(uid, Map<String, dynamic> data) {
    if (data == null || uid == null) {
      return null;
    }
    final String wheelchairID = data['wheelchairID'];
    if (wheelchairID == null) {
      return null;
    }
    final String instruction = data['instruction'];
    if (instruction == null) {
      return null;
    }
    final String console = data['console'];
    if (console == null) {
      return null;
    }
    final String msg = data['msg'];
    if (msg == null) {
      return null;
    }
    final bool request = data['request'];
    if (request == null) {
      return null;
    }
    final bool execute = data['execute'];
    if (execute == null) {
      return null;
    }
    final DateTime createdAt = data['createdAt'].toDate();
    if (createdAt == null) {
      return null;
    }

    return Navigation(
      uid: uid,
      wheelchairID: wheelchairID,
      instruction: instruction,
      console: console,
      msg: msg,
      request: request,
      execute: execute,
      createdAt: createdAt,
    );
  }

  // object to map
  Map<String, dynamic> toMap() {
    return {
      'wheelchairID': wheelchairID,
      'instruction': instruction,
      'console': console,
      'msg': msg,
      'request': request,
      'execute': execute,
      'createdAt': createdAt,
    };
  }
}
