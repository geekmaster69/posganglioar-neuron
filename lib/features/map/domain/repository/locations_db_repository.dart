abstract class LocationsDbRepository {
  Future<void> toggleVisitedLocation(int candyId);

  Future<bool> isVisited(int candyId);

   Future<List<int>> getVisitedLocations();
}
