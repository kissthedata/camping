import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'map_location.dart';

Future<List<MapLocation>> loadLocationsFromCsv(String csvFilePath) async {
  final locations = <MapLocation>[];

  try {
    final csvString = await rootBundle.loadString(csvFilePath);
    final List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

    for (var row in rowsAsListOfValues.skip(1)) {
      if (row.length < 8) continue;

      try {
        final location = MapLocation(
          num: row[0].toString(),
          place: row[1].toString(),
          number: row[2].toString(),
          latitude: double.parse(row[3].toString()),
          longitude: double.parse(row[4].toString()),
          imagePath: row[5].toString(),
          cookingAllowed: row[6].toString().toLowerCase() == 'true',
          hasSink: row[7].toString().toLowerCase() == 'true',
          isRestroom: csvFilePath.contains('restroom'),
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
