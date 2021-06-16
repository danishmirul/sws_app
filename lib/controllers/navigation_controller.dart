import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/navigation.dart';
import '../services/firestore_path.dart';
import '../services/firestore_service.dart';

class NavigationController {
  NavigationController({@required this.firestoreService})
      : assert(firestoreService != null);

  final FirestoreService firestoreService;

  CollectionReference navigations =
      Firestore.instance.collection('navigations');

  Future<bool> createNavigation(Navigation navigation) async {
    return await firestoreService.createNewDocument(navigations, navigation);
  }

  // Get
  Stream<Navigation> navigationStream(String uid) {
    try {
      final path = FirestorePath.navigationPath(uid);
      final reference = Firestore.instance.document(path);
      final snapshots = reference.snapshots();

      return snapshots
          .map((snapshot) => Navigation.fromMap(uid, snapshot.data));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> fetchNavigation(String idWheelchair) async {
    Query query = navigations.where('wheelchairID', isEqualTo: idWheelchair);
    final documents = await firestoreService.getDocumentsQeury(query);

    if (documents != null) {
      if (documents.length > 0) {
        Navigation navigation = Navigation.fromSnapShot(documents[0]);

        return {'status': true, 'data': navigation};
      }
      return {'status': false, 'data': null};
    }

    return {'status': false, 'data': null};
  }

  Future<bool> updateNavigation(Navigation navigation) async {
    final path = FirestorePath.navigationPath(navigation.uid);
    final docRef = Firestore.instance.document(path);
    try {
      return await firestoreService.setDocument(docRef, navigation);
    } catch (e) {
      print(e);
      return false;
    }
  }
}
