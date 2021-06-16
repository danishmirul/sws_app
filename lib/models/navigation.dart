import 'package:cloud_firestore/cloud_firestore.dart';

class Navigation {
  String uid;
  String wheelchairID;
  String instruction;
  bool request;
  DateTime createdAt;

  Navigation({
    this.uid,
    this.wheelchairID,
    this.instruction,
    this.request,
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
          request: from.request,
          createdAt: from.createdAt,
        );

  @override
  String toString() =>
      "{ uid:${this.uid}, wheelchairID:${this.wheelchairID}, instruction:${this.instruction}, request:${this.request} }";

  // initialised through snapshot
  Navigation.fromSnapShot(DocumentSnapshot snapshot) {
    this.uid = snapshot.documentID;
    // this.uuid = snapshot.data['uuid'];
    this.wheelchairID = snapshot.data['wheelchairID'];
    this.instruction = snapshot.data['instruction'];
    this.request = snapshot.data['request'];
    this.createdAt = snapshot.data['createdAt'].toDate();
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
    final bool request = data['request'];
    if (request == null) {
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
      request: request,
      createdAt: createdAt,
    );
  }

  // object to map
  Map<String, dynamic> toMap() {
    return {
      'wheelchairID': wheelchairID,
      'instruction': instruction,
      'request': request,
      'createdAt': createdAt,
    };
  }
}
