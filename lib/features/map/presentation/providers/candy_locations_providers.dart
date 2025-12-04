import 'package:candy_tracker/features/map/domain/domain.dart';
import 'package:candy_tracker/features/map/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final locationProvider = NotifierProvider.autoDispose
    .family<CandyLocationNotifier, CandyLocationsState, (double, double)>(
      CandyLocationNotifier.new,
    );

class CandyLocationNotifier extends Notifier<CandyLocationsState> {
  final (double, double) position;
  late LocationsRepository repository;
  late LocationsDbRepository dbRepository;

  CandyLocationNotifier(this.position);
  @override
  CandyLocationsState build() {
    repository = ref.watch(mapCandyRepositoryProvider);
    dbRepository = ref.watch(candyLocationsDbProvider);

    Future.microtask(() => getLocations());
    return CandyLocationsState();
  }

  Future<void> getLocations() async {
    state = state.copyWith(isLoading: true);

    try {
      final locations = await repository.nervyCandyLocations(
        position.$1,
        position.$2,
      );
      final visitedLocations = await dbRepository.getVisitedLocations();
      final markers = await Future.wait(
        locations.map(
          (e) => _createCustomMarker(e, visitedLocations.contains(e.id)),
        ),
      );
      state = state.copyWith(
        candyLocations: locations,
        isLoading: false,
        markers: markers,
        visitedId: visitedLocations,
      );
    } catch (e) {
      _setMessage(e.toString());
    }
  }

  Future<void> toggleVisitedLocation(int candyId) async {
    await dbRepository.toggleVisitedLocation(candyId);

    final isOnList = state.visitedId.any((element) => element == candyId);
    final newMarker = await _createCustomMarker(
      state.candyLocations.firstWhere((element) => element.id == candyId),
      !isOnList,
    );
    final markersFiltered = state.markers.where(
      (element) => element.mapsId.value != candyId.toString(),
    );

    if (isOnList) {
      final filterList = state.visitedId
          .where((element) => element != candyId)
          .toList();

      state = state.copyWith(
        visitedId: filterList,
        markers: [...markersFiltered, newMarker],
      );
    } else {
      state = state.copyWith(
        visitedId: [...state.visitedId, candyId],
        markers: [...markersFiltered, newMarker],
      );
    }
  }

  Future<Marker> _createCustomMarker(
    MapCandyLocation mapLocation,
    bool isVisited,
  ) async {
    const size = Size(50, 50);
    final icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: size),
      isVisited ? 'assets/icon/pumkin.png' : 'assets/icon/candy_corn.png',
    );

    return Marker(
      rotation:  isVisited ? 0: 180,
      markerId: MarkerId(mapLocation.id.toString()),
      icon: icon,
    
      position: LatLng(mapLocation.latitude, mapLocation.longitude),
    );
  }

  void _setMessage(String message) {
    state = state.copyWith(message: message);
    state = state.copyWith(message: '');
  }
}

class CandyLocationsState {
  final bool isLoading;
  final String message;
  final List<MapCandyLocation> candyLocations;
  final List<Marker> markers;
  final List<int> visitedId;

  CandyLocationsState({
    this.isLoading = true,
    this.message = '',
    this.candyLocations = const [],
    this.markers = const [],
    this.visitedId = const [],
  });

  CandyLocationsState copyWith({
    bool? isLoading,
    String? message,
    List<MapCandyLocation>? candyLocations,
    List<Marker>? markers,
    List<int>? visitedId,
  }) {
    return CandyLocationsState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      candyLocations: candyLocations ?? this.candyLocations,
      markers: markers ?? this.markers,
      visitedId: visitedId ?? this.visitedId,
    );
  }
}
