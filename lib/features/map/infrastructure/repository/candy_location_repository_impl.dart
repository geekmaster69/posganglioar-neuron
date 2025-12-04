import 'package:candy_tracker/features/map/domain/domain.dart';

class CandyLocationRepositoryImpl implements LocationsRepository {
  final LocationsDatasource datasource;

  CandyLocationRepositoryImpl(this.datasource);
  @override
  Future<List<MapCandyLocation>> nervyCandyLocations(
    double latitude,
    double longitude,
  ) {
    return datasource.nervyCandyLocations(latitude, longitude);
  }
}
