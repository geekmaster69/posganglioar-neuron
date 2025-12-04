import 'package:candy_tracker/features/map/domain/domain.dart';

class LocationsDbRepositoryImpl implements LocationsDbRepository {
  final LocationsDbDatasource datasource;

  LocationsDbRepositoryImpl(this.datasource);
  @override
  Future<bool> isVisited(int candyId) {
    return datasource.isVisited(candyId);
  }

  @override
  Future<void> toggleVisitedLocation(int candyId) {
    return datasource.toggleVisitedLocation(candyId);
  }
  
  @override
  Future<List<int>> getVisitedLocations() {
    return datasource.getVisitedLocations();
  }
}
