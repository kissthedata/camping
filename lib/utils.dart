import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'map_location.dart';

Future<List<MapLocation>> loadLocationsFromCsv(String csvFilePath, String category) async {
  final locations = <MapLocation>[];

  try {
    final csvString = await rootBundle.loadString(csvFilePath);
    print('CSV File Loaded: $csvFilePath');
    final List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

    for (var row in rowsAsListOfValues.skip(1)) {
      if (row.length < 3) {
        print('Skipping row with insufficient data: $row');
        continue;
      }

      try {
        final location = MapLocation(
          num: row[0].toString(),
          place: row[0].toString(), // CSV 파일의 첫 번째 열을 num으로 사용합니다.
          latitude: double.parse(row[1].toString()),
          longitude: double.parse(row[2].toString()),
          category: category,
        );
        locations.add(location);
        print('Loaded location: $location');
      } catch (e) {
        print('Error parsing row: $row');
        print('Exception: $e');
      }
    }
  } catch (e) {
    print('Error loading CSV: $csvFilePath: $e');
  }

  return locations;
}
