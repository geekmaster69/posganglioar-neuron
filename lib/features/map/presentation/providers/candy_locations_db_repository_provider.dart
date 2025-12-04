import 'package:candy_tracker/features/map/domain/domain.dart';
import 'package:candy_tracker/features/map/infrastructure/infrastructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final candyLocationsDbProvider = Provider.autoDispose<LocationsDbRepository>((
  ref,
) {
  return LocationsDbRepositoryImpl(LocationsDbDatasourceImpl());
});
