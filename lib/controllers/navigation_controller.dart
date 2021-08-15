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
      FirebaseFirestore.instance.collection('navigations');

  Future<bool> createNavigation(Navigation navigation) async {
    return await firestoreService.createNewDocument(navigations, navigation);
  }

  // Get
  Stream<Navigation> navigationStream(String uid) {
    try {
      var stream = FirebaseFirestore.instance
          .collection('navigations')
          .doc(uid)
          .snapshots();
      return stream.map((document) => Navigation.fromMap(uid, document.data()));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Navigation> fetchNavigation(String idWheelchair) async {
    Query query = navigations.where('wheelchairID', isEqualTo: idWheelchair);
    final documents = await firestoreService.getDocumentsQeury(query);

    if (documents != null) {
      if (documents.length > 0) {
        Navigation navigation = Navigation.fromSnapShot(documents[0]);

        return navigation;
      }
      return null;
    }

    return null;
  }

  Future<bool> updateNavigation(Navigation navigation) async {
    final docRef = FirebaseFirestore.instance
        .collection('navigations')
        .doc(navigation.uid);
    try {
      return await firestoreService.setDocument(docRef, navigation);
    } catch (e) {
      print(e);
      return false;
    }
  }
}
