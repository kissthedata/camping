import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_sample/models/map_location.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLocation(MapLocation location) async {
    try {
      await _firestore.collection('locations').doc(location.num).set(location.toJson());
      print('Location added: ${location.num}');
    } catch (e) {
      print('Error adding location: $e');
      throw e;
    }
  }

  Future<void> addLocations(List<MapLocation> locations) async {
    WriteBatch batch = _firestore.batch();
    for (var location in locations) {
      var docRef = _firestore.collection('locations').doc(location.num);
      batch.set(docRef, location.toJson());
    }
    try {
      await batch.commit();
      print('Batch commit successful');
    } catch (e) {
      print('Error during batch commit: $e');
      throw e;
    }
  }
}
