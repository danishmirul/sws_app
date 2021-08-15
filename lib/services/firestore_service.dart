import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sws_app/models/message.dart';
import 'package:sws_app/models/user.dart';
import 'package:sws_app/models/wheelchair.dart';
import './firestore_path.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference wheelchairs =
      FirebaseFirestore.instance.collection('wheelchairs');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference msgLogs =
      FirebaseFirestore.instance.collection('msgLogs');

  Future<bool> createNewDocument(
      CollectionReference collectionReference, dynamic data) async {
    try {
      await collectionReference.add(data.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<DocumentSnapshot> getDocumentById(
      CollectionReference collectionReference, String id) async {
    try {
      await collectionReference
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          return documentSnapshot.data();
        }
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<DocumentSnapshot>> getDocuments(
      CollectionReference collectionReference) async {
    try {
      final querySnapshot = await collectionReference.get();
      final documents = querySnapshot.docs;
      return documents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<DocumentSnapshot>> getDocumentsQeury(Query query) async {
    try {
      final querySnapshot = await query.get();
      final documents = querySnapshot.docs;
      return documents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> setDocument(
      DocumentReference documentReference, dynamic data) async {
    try {
      await documentReference.set(data.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //STREAMS
  Stream<DocumentSnapshot> getDocumentSnapshot(
      DocumentReference documentReference) {
    try {
      final snapshots = documentReference.snapshots();

      print('Stream: $snapshots');
      return snapshots;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> getDocumentsSnapshot(
      CollectionReference collectionReference) {
    try {
      final snapshots = collectionReference.snapshots();
      print('Stream: $snapshots');
      return snapshots;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> getDocumentsSnapshotQuery(Query query) {
    try {
      final snapshots = query.snapshots();
      print('Stream: $snapshots');
      return snapshots;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Get
  Future getWheelchair(String id) async {
    final doc = await wheelchairs.doc(id).get();
    return Wheelchair.fromSnapShot(doc);
  }

  // Get
  Future<List<User>> getSupporters() async {
    final querySnapshot = await users.where('hotline', isEqualTo: true).get();

    final documents = querySnapshot.docs;
    List<User> supporters = [];
    documents.forEach((e) => supporters.add(User.fromSnapShot(e)));

    return supporters;
  }

  // Get
  Future<Wheelchair> getWheelchairDevice(
      {@required String name, @required String address}) async {
    final querySnapshot = await wheelchairs
        .where('name', isEqualTo: name)
        .where('address', isEqualTo: address)
        .where('accessible', isEqualTo: true)
        .get();

    final documents = querySnapshot.docs;

    if (documents.length > 0) {
      return Wheelchair.fromSnapShot(documents[0]);
    } else
      return null;
  }

  void updateBatteryWheelchair(String id, String battery) {
    wheelchairs
        .doc(id)
        .update({'battery': battery, 'status': battery == 'HIGH' ? 'A' : 'U'})
        .then((value) => print("Battery Wheelchair Updated"))
        .catchError(
            (error) => print("Failed to update status wheelchair: $error"));
  }

  void addMessageLog(Message message) {
    msgLogs
        .add(message.toMap())
        .then((value) => print("Message Log Updated"))
        .catchError((error) => print("Failed to add message log: $error"));
  }

  void updateWheelchair(Wheelchair wheelchair) {
    wheelchairs.doc(wheelchair.uid).set(wheelchair.toMap());
  }

  // Reads the current user data
  Stream<Wheelchair> wheelchairReferenceStream(String uid) {
    try {
      print('UID: $uid');
      final path = FirestorePath.wheelchairPath(uid);
      final reference = FirebaseFirestore.instance.doc(path);
      final snapshots = reference.snapshots();

      print('snapshots: $snapshots');
      return snapshots
          .map((snapshot) => Wheelchair.fromMap(uid, snapshot.data()));
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Set the user data
  Future<void> setWheelchairReference(Wheelchair wheelchairReference) async {
    try {
      final path = FirestorePath.wheelchairPath(wheelchairReference.uid);
      final reference = FirebaseFirestore.instance.doc(path);
      await reference.set(wheelchairReference.toMap());
    } catch (e) {
      print(e);
      return null;
    }
  }
}
