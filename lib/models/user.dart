import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String fullname;
  String email;
  String phone;
  bool hotline;
  bool accessible;
  DateTime createdAt;

  // constructor
  User({
    this.uid,
    this.email,
    this.fullname,
    this.phone,
    this.hotline,
    this.accessible = true,
    createdAt,
  }) {
    if (createdAt == null || createdAt == 0)
      this.createdAt = DateTime.now();
    else
      this.createdAt = createdAt;
  }

  // copy
  User.copy(User from)
      : this(
          uid: from.uid,
          fullname: from.fullname,
          email: from.email,
          phone: from.phone,
          hotline: from.hotline,
          accessible: from.accessible,
          createdAt: from.createdAt,
        );

  @override
  String toString() =>
      "{ uid:${this.uid}, fullname:${this.fullname}, email:${this.email}, phone:${this.phone}, hotline:${this.hotline}, accessible:${this.accessible} }";

  // initialised through snapshot
  User.fromSnapShot(DocumentSnapshot snapshot) {
    this.uid = snapshot.documentID;
    this.fullname = snapshot.data['fullname'];
    this.email = snapshot.data['email'];
    this.phone = snapshot.data['phone'];
    this.hotline = snapshot.data['hotline'];
    this.accessible = snapshot.data['accessible'];
    this.createdAt = snapshot.data['createdAt'].toDate();
  }

  // map to object
  factory User.fromMap(uid, Map<String, dynamic> data) {
    if (data == null || uid == null) {
      return null;
    }
    final String email = data['email'];
    if (email == null) {
      return null;
    }
    final String fullname = data['fullname'];
    if (fullname == null) {
      return null;
    }
    final String phone = data['phone'];
    if (phone == null) {
      return null;
    }
    final bool hotline = data['hotline'];
    if (hotline == null) {
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

    return User(
      uid: uid,
      email: email,
      fullname: fullname,
      phone: phone,
      hotline: hotline,
      accessible: accessible,
      createdAt: createdAt,
    );
  }

  // object to map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullname': fullname,
      'phone': phone,
      'hotline': hotline,
      'accessible': accessible,
      'createdAt': createdAt,
    };
  }
}
