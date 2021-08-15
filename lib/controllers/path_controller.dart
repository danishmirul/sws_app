import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class PathController {
  PathController({@required this.firestoreService})
      : assert(firestoreService != null);

  final FirestoreService firestoreService;

  CollectionReference paths = FirebaseFirestore.instance.collection('paths/');

  //  STREAM

  Future<bool> createSemiAutoNavigation(Path path) async {
    return await firestoreService.createNewDocument(paths, path);
  }

  // Future<Path> getPath(String wheelchairId) async {
  //   DateTime now = DateTime.now();
  //   Query query = paths
  //       .where('wheelchairId', isEqualTo: wheelchairId)
  //       .where('createdAt', isEqualTo: DateTime.now())
  //       .orderBy('createdAt', descending: true);
  //   final documents = await firestoreService.getDocumentsQeury(query);

  //   List<Path> wheelchairList = <Path>[];
  //   wheelchairList =
  //       documents.map((e) => Path.fromMap(e.documentID, e.data)).toList();

  //   return wheelchairList;
  // }

  String getStringSource(int param) =>
      param == 0 ? 'Source: Client' : 'Source: Wheelchair';
}
