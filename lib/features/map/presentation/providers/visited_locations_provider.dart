import 'package:candy_tracker/features/map/domain/domain.dart';
import 'package:candy_tracker/features/map/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final visitedLocationsProvider =
    NotifierProvider.autoDispose<VisitedLocationsNotifier, List<int>>(
      VisitedLocationsNotifier.new,
    );

class VisitedLocationsNotifier extends Notifier<List<int>> {
  late LocationsDbRepository dbRepository;

  @override
  List<int> build() {
    dbRepository = ref.watch(candyLocationsDbProvider);
    Future.microtask(() => getVisitedLocations());
    return [];
  }

  Future<void> getVisitedLocations() async {
    try {
      final visitedId = await dbRepository.getVisitedLocations();

      state = visitedId;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> toggleVisitedLocation(int candyId) async {
    await dbRepository.toggleVisitedLocation(candyId);

    if (state.any((element) => element == candyId)) {
      final filterList = state.where((element) => element != candyId).toList();

      state = filterList;
    } else {
      state = [...state, candyId];
    }
  }
}
