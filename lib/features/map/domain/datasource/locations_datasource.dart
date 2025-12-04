import 'package:candy_tracker/features/map/domain/entities/map_candy_location.dart';

abstract class LocationsDatasource {
  Future<List<MapCandyLocation>> nervyCandyLocations(double latitude, double longitude);
}
