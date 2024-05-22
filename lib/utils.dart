import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'map_location.dart';

Future<List<MapLocation>> loadLocationsFromCsv(String csvFilePath, String imagePath) async {
  final locations = <MapLocation>[];

  try {
    final csvString = await rootBundle.loadString(csvFilePath);
    final List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

    for (var row in rowsAsListOfValues.skip(1)) {
      if (row.length < 5) {
        continue;
      }

      try {
        final location = MapLocation(
          num: row[0].toString(),
          place: row[1].toString(),
          number: row[2].toString(),
          latitude: double.parse(row[3].toString()),
          longitude: double.parse(row[4].toString()),
          imagePath: imagePath,
        );
        locations.add(location);
      } catch (e) {
        print('Error parsing row: $row');
      }
    }
  } catch (e) {
    print('Error loading CSV: $csvFilePath');
  }

  return locations;
}
