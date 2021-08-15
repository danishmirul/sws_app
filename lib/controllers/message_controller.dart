import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class MessageController {
  MessageController({@required this.firestoreService})
      : assert(firestoreService != null);

  final FirestoreService firestoreService;

  CollectionReference msgLogs =
      FirebaseFirestore.instance.collection('msgLogs/');

  //  STREAM

  Stream<QuerySnapshot> wheelchairMessagesStream(String idWheelchair,
      {int length = 10}) {
    try {
      final query = msgLogs
          .where('wheelchairId', isEqualTo: idWheelchair)
          .orderBy('createdAt', descending: true)
          .limit(length);
      return firestoreService.getDocumentsSnapshotQuery(query);
    } catch (e) {
      print(e);
      return null;
    }
  }

  String getStringSource(int param) =>
      param == 0 ? 'Source: Client' : 'Source: Wheelchair';
}
