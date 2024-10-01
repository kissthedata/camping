// recommendation_system.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:map_sample/models/car_camping_site.dart';

class RecommendationSystem {
  Future<List<CarCampingSite>> recommendCampingSites(String userId) async {
    // Recommendation logic based on user preferences
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('car_camping_sites');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      List<CarCampingSite> recommendedSites = [];
      Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);

      int count = 0;
      for (var entry in data.entries) {
        if (count >= 4) break;  // Limit to 4 recommendations for now
        Map<String, dynamic> siteData = Map<String, dynamic>.from(entry.value);
        CarCampingSite site = CarCampingSite(
          name: siteData['place'],
          latitude: siteData['latitude'],
          longitude: siteData['longitude'],
          address: siteData['address'] ?? '',
          imageUrl: siteData['imageUrl'] ?? '',
          restRoom: siteData['restRoom'] ?? false,
          sink: siteData['sink'] ?? false,
          cook: siteData['cook'] ?? false,
          animal: siteData['animal'] ?? false,
          water: siteData['water'] ?? false,
          parkinglot: siteData['parkinglot'] ?? false,
          details: siteData['details'] ?? '',
          isVerified: true,
        );
        recommendedSites.add(site);
        count++;
      }
      return recommendedSites;
    }

    return [];
  }
}
