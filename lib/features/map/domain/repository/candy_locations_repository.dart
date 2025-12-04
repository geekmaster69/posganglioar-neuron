import 'package:candy_tracker/features/map/domain/domain.dart';

abstract class LocationsRepository {
  Future<List<MapCandyLocation>> nervyCandyLocations(double latitude, double longitude);
}
