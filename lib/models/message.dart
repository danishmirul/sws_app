import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String uid;
  String wheelchairId;
  int whom;
  String label;
  String text;
  DateTime createdAt;

  Message({
    this.uid,
    this.wheelchairId,
    this.whom,
    this.label,
    this.text,
    createdAt,
  }) {
    if (createdAt == null || createdAt == 0)
      this.createdAt = DateTime.now();
    else
      this.createdAt = createdAt;
  }

  @override
  String toString() {
    return '{ wheelchairId: ${this.wheelchairId}, whom: ${this.whom}, label: ${this.label}, text: ${this.text}, createdAt: ${this.createdAt} }';
  }

  // initialised through snapshot
  Message.fromSnapShot(DocumentSnapshot snapshot) {
    this.uid = snapshot.documentID;
    // this.uuid = snapshot.data['uuid'];
    this.wheelchairId = snapshot.data['wheelchairId'];
    this.whom = snapshot.data['whom'] as num;
    this.label = snapshot.data['label'];
    this.text = snapshot.data['text'];
    this.createdAt = snapshot.data['createdAt'].toDate();
  }

  // map to object
  factory Message.fromMap(uid, Map<String, dynamic> data) {
    if (data == null || uid == null) {
      return null;
    }
    final String wheelchairId = data['wheelchairId'];
    if (wheelchairId == null) {
      return null;
    }
    final int whom = data['whom'];
    if (whom == null) {
      return null;
    }
    final String label = data['label'];
    if (label == null) {
      return null;
    }
    final String text = data['text'];
    if (text == null) {
      return null;
    }
    final DateTime createdAt = data['createdAt'].toDate();
    if (createdAt == null) {
      return null;
    }

    return Message(
      uid: uid,
      wheelchairId: wheelchairId,
      whom: whom,
      label: label,
      text: text,
      createdAt: createdAt,
    );
  }

  // object to map
  Map<String, dynamic> toMap() {
    return {
      'wheelchairId': wheelchairId,
      'whom': whom,
      'label': label,
      'text': text,
      'createdAt': createdAt,
    };
  }
}
