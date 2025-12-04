import 'package:candy_tracker/features/store/domain/domain.dart';

abstract class CandyLocationDatasource {
  Future<List<CandyLocation>> locationsForUser();

  Future<CandyLocation> getCandyLocationById(int id);

  Future<CandyLocation> createUpdateCandyLocation(
    Map<String, dynamic> likeCandyLocation,
  );
}
