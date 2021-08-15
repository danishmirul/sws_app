import 'package:cloud_firestore/cloud_firestore.dart';

class Wheelchair {
  String uid;
  String name;
  String address;
  String plate;
  String battery;
  String status;
  // List<Log> logs;
  bool accessible;
  DateTime createdAt;

  Wheelchair({
    this.uid,
    this.name,
    this.address,
    this.plate,
    this.battery,
    this.status,
    // this.logs,
    this.accessible = true,
    createdAt,
  }) {
    if (createdAt == null || createdAt == 0)
      this.createdAt = DateTime.now();
    else
      this.createdAt = createdAt;
  }

  Wheelchair.copy(Wheelchair from)
      : this(
          uid: from.uid,
          name: from.name,
          address: from.address,
          plate: from.plate,
          battery: from.battery,
          status: from.status,
          accessible: from.accessible,
          createdAt: from.createdAt,
        );

  @override
  String toString() =>
      "{ uid:${this.uid}, name:${this.name}, address:${this.address}, plate:${this.plate}, battery:${this.battery}, status:${this.status}, accessible:${this.accessible} }";

  // initialised through snapshot
  Wheelchair.fromSnapShot(DocumentSnapshot snapshot) {
    this.uid = snapshot.id;
    // this.uuid = snapshot.data['uuid'];
    this.name = snapshot.get(FieldPath(['name']));
    this.address = snapshot.get(FieldPath(['address']));
    this.plate = snapshot.get(FieldPath(['plate']));
    this.battery = snapshot.get(FieldPath(['battery']));
    this.status = snapshot.get(FieldPath(['status']));
    // this.logs = snapshot.data['logs'];
    this.accessible = snapshot.get(FieldPath(['accessible']));
    this.createdAt = snapshot.get(FieldPath(['createdAt'])).toDate();
  }

  // map to object
  factory Wheelchair.fromMap(uid, Map<String, dynamic> data) {
    if (data == null || uid == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) {
      return null;
    }
    final String address = data['address'];
    if (address == null) {
      return null;
    }
    final String plate = data['plate'];
    if (plate == null) {
      return null;
    }
    final String battery = data['battery'];
    if (battery == null) {
      return null;
    }
    final String status = data['status'];
    if (status == null) {
      return null;
    }
    final bool accessible = data['accessible'];
    if (accessible == null) {
      return null;
    }
    final DateTime createdAt = data['createdAt'].toDate();
    if (createdAt == null) {
      return null;
    }

    return Wheelchair(
      uid: uid,
      name: name,
      address: address,
      plate: plate,
      battery: battery,
      status: status,
      accessible: accessible,
      createdAt: createdAt,
    );
  }

  // object to map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'plate': plate,
      'battery': battery,
      'status': status,
      'accessible': accessible,
      'createdAt': createdAt,
    };
  }
}
