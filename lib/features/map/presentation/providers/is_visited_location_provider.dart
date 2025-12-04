import 'package:candy_tracker/features/map/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isVisitedLocationProvider = FutureProvider.autoDispose.family<bool, int>((
  ref,
  candyId,
) async {
  final locationDbRepository = ref.watch(candyLocationsDbProvider);

  return locationDbRepository.isVisited(candyId);
});
