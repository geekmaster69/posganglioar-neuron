import 'package:candy_tracker/features/store/domain/domain.dart';


class CandyLocationRepositoryImpl implements CandyLocationRepository {
  final CandyLocationDatasource datasource;

  CandyLocationRepositoryImpl(this.datasource);
  @override
  Future<List<CandyLocation>> locationsForUser() {
   return datasource.locationsForUser();
  }
  
  @override
  Future<CandyLocation> getCandyLocationById(int id) {
    return datasource.getCandyLocationById(id);
  }
  
  @override
  Future<CandyLocation> createUpdateCandyLocation(Map<String, dynamic> likeCandyLocation) {
   return datasource.createUpdateCandyLocation(likeCandyLocation);
  }
  
  @override
  Future<String> deleteCandyLocationById(int id) {
   return datasource.deleteCandyLocationById(id);
  }
}
