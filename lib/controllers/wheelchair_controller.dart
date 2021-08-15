import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/wheelchair.dart';
import '../services/firestore_path.dart';
import '../services/firestore_service.dart';

class WheelchairController {
  WheelchairController({@required this.firestoreService})
      : assert(firestoreService != null);

  final FirestoreService firestoreService;

  CollectionReference wheelchairs =
      FirebaseFirestore.instance.collection('wheelchairs');

  //  CRUD
  //  CREATE

  Future<bool> createNewWheelchair(Wheelchair wheelchair) async {
    return await firestoreService.createNewDocument(wheelchairs, wheelchair);
  }

  //  READ

  Future<Wheelchair> getWheelchairById(String id) async {
    final documents = await firestoreService.getDocumentById(wheelchairs, id);
    return documents != null ? Wheelchair.fromSnapShot(documents) : null;
  }

  Future<List<Wheelchair>> getWheelchairs() async {
    final documents = await firestoreService.getDocuments(wheelchairs);

    List<Wheelchair> wheelchairList = <Wheelchair>[];
    wheelchairList =
        documents.map((e) => Wheelchair.fromMap(e.id, e.data())).toList();

    return wheelchairList;
  }

  Future<List<Wheelchair>> getAvailableWheelchairs() async {
    Query query = wheelchairs
        .limit(4)
        .where('battery', isEqualTo: 'HIGH')
        .where('status', isEqualTo: 'A')
        .where('accessible', isEqualTo: true);
    final documents = await firestoreService.getDocumentsQeury(query);

    List<Wheelchair> wheelchairList = <Wheelchair>[];
    wheelchairList =
        documents.map((e) => Wheelchair.fromMap(e.id, e.data())).toList();

    return wheelchairList;
  }

  List<DocumentSnapshot> paginatedDocumentList = [];
  int index = 0;
  Future<List<Wheelchair>> getPaginatedWheelchair(
      {bool next = true, int length = 10}) async {
    Query query;
    final temp = await getWheelchairs();
    final total = temp.length;
    print('index: $index');

    try {
      if (next) {
        if (index == 0) {
          query =
              wheelchairs.orderBy('createdAt', descending: true).limit(length);
          List<DocumentSnapshot> snapshots =
              await firestoreService.getDocumentsQeury(query);
          paginatedDocumentList = snapshots;

          List<Wheelchair> wheelchairList = <Wheelchair>[];
          wheelchairList =
              snapshots.map((e) => Wheelchair.fromMap(e.id, e.data())).toList();

          index = wheelchairList.length;

          return wheelchairList;
        } else if (index < total) {
          query = wheelchairs
              .orderBy('createdAt', descending: true)
              .startAfterDocument(paginatedDocumentList[index - 1])
              .limit(length);
          List<DocumentSnapshot> snapshots =
              await firestoreService.getDocumentsQeury(query);
          paginatedDocumentList.addAll(snapshots);

          List<Wheelchair> wheelchairList = <Wheelchair>[];
          wheelchairList =
              snapshots.map((e) => Wheelchair.fromMap(e.id, e.data())).toList();

          index = paginatedDocumentList.length;

          return wheelchairList;
        }
        return [];
      } else {
        if (index == 0 || index == length) {
          return [];
        } else if (index == total) {
          int remainder = index % length;

          int startIndex = remainder > 0
              ? total - (remainder + length)
              : total - (length * 2);

          List<DocumentSnapshot> snapshots =
              paginatedDocumentList.sublist(startIndex, startIndex + length);

          paginatedDocumentList.removeRange(
              startIndex + 1, paginatedDocumentList.length);

          index = paginatedDocumentList.length;

          List<Wheelchair> wheelchairList = <Wheelchair>[];
          wheelchairList =
              snapshots.map((e) => Wheelchair.fromMap(e.id, e.data())).toList();

          print('wheelchairList: ${wheelchairList.length}');
          return wheelchairList;
        } else {
          int startIndex = paginatedDocumentList.length - (length * 2);

          List<DocumentSnapshot> snapshots =
              paginatedDocumentList.sublist(startIndex, startIndex + length);

          paginatedDocumentList.removeRange(
              startIndex + 1, paginatedDocumentList.length);

          index = paginatedDocumentList.length;

          List<Wheelchair> wheelchairList = <Wheelchair>[];
          wheelchairList =
              snapshots.map((e) => Wheelchair.fromMap(e.id, e.data())).toList();

          return wheelchairList;
        }
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  //  UPDATE
  Future<bool> updateWheelchair(Wheelchair wheelchair) async {
    final path = FirestorePath.wheelchairPath(wheelchair.uid);
    final docRef = FirebaseFirestore.instance.doc(path);
    return await firestoreService.setDocument(docRef, wheelchair);
  }

  //  STREAM
  Stream<Wheelchair> wheelchairReferenceStream(String id) {
    try {
      final path = FirestorePath.wheelchairPath(id);
      final docRef = FirebaseFirestore.instance.doc(path);
      final snapshots = firestoreService.getDocumentSnapshot(docRef);
      final stream =
          snapshots.map((snapshot) => Wheelchair.fromMap(id, snapshot.data()));

      print('Stream: $stream');

      return stream;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<Wheelchair>> wheelchairsReferenceStream() {
    try {
      final snapshots = firestoreService.getDocumentsSnapshot(wheelchairs);
      final stream = snapshots.map((snapshot) => snapshot.docs
          .map((doc) => Wheelchair.fromMap(doc.id, doc.data()))
          .toList());

      print('Stream: $stream');

      return stream;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String getStatusString(String param) {
    if (param == 'A') {
      return 'Available';
    } else if (param == 'U') {
      return 'In use';
    }

    return 'Maintenance';
  }

  Color getStatusColor(String param) {
    if (param == 'A') {
      return Colors.green;
    } else if (param == 'U') {
      return Colors.yellow;
    }

    return Colors.deepOrange;
  }

  String getAccessibilityString(bool param) =>
      param ? 'Accessible' : 'Inacessible';
}
