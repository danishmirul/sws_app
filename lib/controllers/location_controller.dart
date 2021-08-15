import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/location.dart';
import '../models/wheelchair.dart';
import '../services/firestore_service.dart';

class LocationController {
  LocationController({@required this.firestoreService})
      : assert(firestoreService != null);

  final FirestoreService firestoreService;

  CollectionReference locations =
      FirebaseFirestore.instance.collection('locations');
  CollectionReference coordinates =
      FirebaseFirestore.instance.collection('coordinates');

  // Get
  Stream<QuerySnapshot> liveLocationStream() {
    try {
      final query = locations.orderBy('createdAt', descending: true).limit(1);
      return firestoreService.getDocumentsSnapshotQuery(query);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> coordinatesStream() {
    try {
      final query = coordinates.orderBy('createdAt', descending: true).limit(1);
      return firestoreService.getDocumentsSnapshotQuery(query);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
