import 'package:candy_tracker/features/store/presentation/providers/location_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:candy_tracker/features/store/domain/domain.dart';

final candyLocationProvider = FutureProvider.autoDispose
    .family<CandyLocation, int>((ref, id) async {
      final repository = ref.watch(candyLocationRepositoryProvider);

      return (id == -1)
          ? CandyLocation(
              id: id,
              isActive: true,
              title: '',
              description: '',
              promotions: [],
              quantity: 100,
              latitude: 0.0,
              longitude: 0.0,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              storeImages: [],
            )
          : await repository.getCandyLocationById(id);
    });
