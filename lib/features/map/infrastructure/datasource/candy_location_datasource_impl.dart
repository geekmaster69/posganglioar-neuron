import 'package:candy_tracker/config/config.dart';

import 'package:dio/dio.dart';

import 'package:candy_tracker/features/map/domain/domain.dart';

class CandyLocationDatasourceImpl implements LocationsDatasource {
  final Dio dio;

  CandyLocationDatasourceImpl()
    : dio = Dio(BaseOptions(baseUrl: Environments.apiUrl));
  @override
  Future<List<MapCandyLocation>> nervyCandyLocations(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await dio.get(
        '${Environments.locations}?lat=$latitude&lng=$longitude',
      );
      final data = response.data as List;

      return data.map((e) => MapCandyLocation.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
