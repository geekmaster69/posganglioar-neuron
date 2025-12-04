import 'package:candy_tracker/config/config.dart';
import 'package:candy_tracker/features/store/infrastructure/errors/candy_location_error.dart';
import 'package:dio/dio.dart';

import 'package:candy_tracker/features/store/domain/domain.dart';

class CandyLocationDatasourceImpl implements CandyLocationDatasource {
  final Dio dio;
  final String accessToken;

  CandyLocationDatasourceImpl(this.accessToken)
    : dio = Dio(
        BaseOptions(
          baseUrl: Environments.apiUrl,
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
  @override
  Future<List<CandyLocation>> locationsForUser() async {
    try {
      final response = await dio.get(Environments.locationsUserPath);

      final data = response.data as List;

      return data.map((e) => CandyLocation.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<CandyLocation> getCandyLocationById(int id) async {
    try {
      final response = await dio.get('/locations/$id');

      return CandyLocation.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw CandyLocationNotFound();
      throw Exception();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<CandyLocation> createUpdateCandyLocation(
    Map<String, dynamic> likeCandyLocation,
  ) async {
    try {
      int? id = likeCandyLocation['id'];

      final String method = (id == null) ? 'POST' : 'PATCH';

      final String url = (id == null) ? '/locations' : '/locations/$id';

      likeCandyLocation.remove('id');

      likeCandyLocation['images'] = await _uploadImages(
        likeCandyLocation['images'],
      );

      final response = await dio.request(
        url,
        data: likeCandyLocation,
        options: Options(method: method),
      );

      return CandyLocation.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName),
      });

      final respose = await dio.post('/files/upload', data: data);

      return respose.data['url'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Map<String, dynamic>>> _uploadImages(
    List<Map<String, dynamic>> images,
  ) async {
    final imagesToSave = images.where((e) => e['id'] == null);
    final imagesToIgnore = images.where((e) => e['id'] != null);

    final List<Future<String>> imagesJob = imagesToSave
        .map((e) => _uploadFile(e['url']))
        .toList();

    final newImages = (await Future.wait(imagesJob)).map((e) => {'url': e});

    return [...imagesToIgnore, ...newImages];
  }
}
