import 'package:cloud_firestore/cloud_firestore.dart';

class Path {
  String uid;
  String wheelchairId;
  String origin;
  String destination;
  DateTime createdAt;

  Path({
    this.uid,
    this.wheelchairId,
    this.origin,
    this.destination,
    createdAt,
  }) {
    if (createdAt == null || createdAt == 0)
      this.createdAt = DateTime.now();
    else
      this.createdAt = createdAt;
  }

  @override
  String toString() {
    return '{ wheelchairId: ${this.wheelchairId}, origin: ${this.origin}, destination: ${this.destination}, createdAt: ${this.createdAt} }';
  }

  // initialised through snapshot
  Path.fromSnapShot(DocumentSnapshot snapshot) {
    this.uid = snapshot.id;
    this.wheelchairId = snapshot.get(FieldPath(['wheelchairId']));
    this.origin = snapshot.get(FieldPath(['origin']));
    this.destination = snapshot.get(FieldPath(['destination']));
    this.createdAt = snapshot.get(FieldPath(['createdAt'])).toDate();
  }

  // map to object
  factory Path.fromMap(uid, Map<String, dynamic> data) {
    if (data == null || uid == null) {
      return null;
    }
    final String wheelchairId = data['wheelchairId'];
    if (wheelchairId == null) {
      return null;
    }
    final String origin = data['origin'];
    if (origin == null) {
      return null;
    }
    final String destination = data['destination'];
    if (destination == null) {
      return null;
    }
    final DateTime createdAt = data['createdAt'].toDate();
    if (createdAt == null) {
      return null;
    }

    return Path(
      uid: uid,
      wheelchairId: wheelchairId,
      origin: origin,
      destination: destination,
      createdAt: createdAt,
    );
  }

  // object to map
  Map<String, dynamic> toMap() {
    return {
      'wheelchairId': wheelchairId,
      'origin': origin,
      'destination': destination,
      'createdAt': createdAt,
    };
  }
}
