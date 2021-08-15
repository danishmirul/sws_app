import 'package:cloud_firestore/cloud_firestore.dart';

class Coordinate {
  String uid;
  List data;
  DateTime createdAt;

  Coordinate({
    this.uid,
    this.data,
    createdAt,
  }) {
    if (createdAt == null || createdAt == 0)
      this.createdAt = DateTime.now();
    else
      this.createdAt = createdAt;
  }

  Coordinate.copy(Coordinate from)
      : this(
          uid: from.uid,
          data: from.data,
          createdAt: from.createdAt,
        );

  @override
  String toString() => "{ uid:${this.uid}, data:${this.data} }";

  // initialised through snapshot
  Coordinate.fromSnapShot(DocumentSnapshot snapshot) {
    this.uid = snapshot.id;
    this.data = snapshot.get(FieldPath(['data']));
    this.createdAt = snapshot.get(FieldPath(['createdAt'])).toDate();
  }

  // map to object
  factory Coordinate.fromMap(uid, Map<String, dynamic> data) {
    if (data == null || uid == null) {
      return null;
    }
    final List _data = data['data'];
    if (_data == null) {
      return null;
    }
    final DateTime createdAt = data['createdAt'].toDate();
    if (createdAt == null) {
      return null;
    }

    return Coordinate(
      uid: uid,
      data: _data,
      createdAt: createdAt,
    );
  }

  // object to map
  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'createdAt': createdAt,
    };
  }
}
