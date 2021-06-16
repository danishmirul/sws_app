import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String uid;
  String wheelchairID;
  String name;
  DateTime createdAt;

  Location({
    this.uid,
    this.wheelchairID,
    this.name,
    createdAt,
  }) {
    if (createdAt == null || createdAt == 0)
      this.createdAt = DateTime.now();
    else
      this.createdAt = createdAt;
  }

  Location.copy(Location from)
      : this(
          uid: from.uid,
          wheelchairID: from.wheelchairID,
          name: from.name,
          createdAt: from.createdAt,
        );

  @override
  String toString() =>
      "{ uid:${this.uid}, wheelchairID:${this.wheelchairID}, name:${this.name} }";

  // initialised through snapshot
  Location.fromSnapShot(DocumentSnapshot snapshot) {
    this.uid = snapshot.documentID;
    // this.uuid = snapshot.data['uuid'];
    this.wheelchairID = snapshot.data['wheelchairID'];
    this.name = snapshot.data['name'];
    this.createdAt = snapshot.data['createdAt'].toDate();
  }

  // map to object
  factory Location.fromMap(uid, Map<String, dynamic> data) {
    if (data == null || uid == null) {
      return null;
    }
    final String wheelchairID = data['wheelchairID'];
    if (wheelchairID == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) {
      return null;
    }
    final DateTime createdAt = data['createdAt'].toDate();
    if (createdAt == null) {
      return null;
    }

    return Location(
      uid: uid,
      wheelchairID: wheelchairID,
      name: name,
      createdAt: createdAt,
    );
  }

  // object to map
  Map<String, dynamic> toMap() {
    return {
      'wheelchairID': wheelchairID,
      'name': name,
      'createdAt': createdAt,
    };
  }
}
