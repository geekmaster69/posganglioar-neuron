import 'package:candy_tracker/config/config.dart';
import 'package:candy_tracker/features/map/presentation/providers/providers.dart';
import 'package:candy_tracker/features/map/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesView extends ConsumerWidget {
  final (double, double) location;
  const PlacesView({super.key, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsState = ref.watch(locationProvider(location));
    final locationNotifier = ref.read(locationProvider(location).notifier);

    bool isVisited(int candyId) {
      return locationsState.visitedId.any((element) => element == candyId);
    }

    String getDistance(double latitude, double longitude) {
      return GeolocatorPlugin()
          .distanceBetween(locationsState.position.$1, locationsState.position.$2, latitude, longitude)
          .toStringAsFixed(2);
    }

    return (locationsState.candyLocations.isEmpty)
        ? const Center(child: Text('Sin datos'))
        : ListView.builder(
            itemCount: locationsState.candyLocations.length,
            itemBuilder: (context, index) {
              final candyLocation = locationsState.candyLocations[index];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.store_outlined),
                  title: Text(candyLocation.title),

                  subtitle: Text(
                    'Distancia: ${getDistance(candyLocation.latitude, candyLocation.longitude)} m',
                  ),
                  trailing: Image.asset(
                    isVisited(candyLocation.id)
                        ? 'assets/icon/pumkin.png'
                        : 'assets/icon/candy_corn.png',
                    width: 30,
                    height: 30,
                  ),
                  onTap: () {
                    showCandyLocationDetails(
                      context,
                      locationCandy: candyLocation,
                      toggleVisited: () {
                        locationNotifier.toggleVisitedLocation(
                          candyLocation.id,
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
  }
}
