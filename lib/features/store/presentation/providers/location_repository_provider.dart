import 'package:candy_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:candy_tracker/features/store/domain/repository/candy_location_repository.dart';
import 'package:candy_tracker/features/store/infrastructure/infrastructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final candyLocationRepositoryProvider = Provider<CandyLocationRepository>((ref) {
  final token = ref.watch(authProvider).user!.token;
  return CandyLocationRepositoryImpl(CandyLocationDatasourceImpl(token));
});
