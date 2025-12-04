import 'package:flutter_riverpod/legacy.dart';

import 'package:candy_tracker/features/store/domain/domain.dart';
import 'package:candy_tracker/features/store/presentation/providers/location_repository_provider.dart';

final candysLocationsProvider =
    StateNotifierProvider.autoDispose<UserLocationNotifier, UserLocationsState>(
      (ref) {
        return UserLocationNotifier(
          repository: ref.watch(candyLocationRepositoryProvider),
        );
      },
    );

class UserLocationNotifier extends StateNotifier<UserLocationsState> {
  final CandyLocationRepository repository;
  UserLocationNotifier({required this.repository})
    : super(UserLocationsState()) {
    _loadData();
  }

  Future<void> _loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final locations = await repository.locationsForUser();
      if (!mounted) return;

      state = state.copyWith(locations: locations, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      setMessage(e.toString());
    }
  }

  Future<bool> createUpdateCandyLocation(
    Map<String, dynamic> likeCandyLocation,
  ) async {
    try {
      final candyLocation = await repository.createUpdateCandyLocation(
        likeCandyLocation,
      );

      final isOnList = state.locations.any(
        (element) => element.id == candyLocation.id,
      );

      if (isOnList) {
        state = state.copyWith(
          locations: state.locations
              .map(
                (element) =>
                    element.id == candyLocation.id ? candyLocation : element,
              )
              .toList(),
        );
      } else {
        state = state.copyWith(locations: [candyLocation, ...state.locations]);
      }
      return true;
    } catch (e) {
      setMessage(e.toString());
      print(e);
      return false;
    }
  }

  void setMessage(String message) {
    if (!mounted) return;
    state = state.copyWith(message: message);
    state = state.copyWith(message: '');
  }
}

class UserLocationsState {
  final bool isLoading;
  final String message;
  final List<CandyLocation> locations;

  UserLocationsState({
    this.isLoading = false,
    this.message = '',
    this.locations = const [],
  });

  UserLocationsState copyWith({
    bool? isLoading,
    String? message,
    List<CandyLocation>? locations,
  }) {
    return UserLocationsState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      locations: locations ?? this.locations,
    );
  }
}
