import '../domain.dart';

abstract class CandyLocationRepository {
  Future<List<CandyLocation>> locationsForUser();

  Future<CandyLocation> getCandyLocationById(int id);

  Future<CandyLocation> createUpdateCandyLocation(
    Map<String, dynamic> likeCandyLocation,
  );
}
