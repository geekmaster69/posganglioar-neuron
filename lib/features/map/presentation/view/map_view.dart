import 'dart:ui';

import 'package:candy_tracker/features/map/presentation/providers/providers.dart';
import 'package:candy_tracker/features/map/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:candy_tracker/config/config.dart';

class CandyMapView extends ConsumerWidget {
  final (double, double) location;
  const CandyMapView({super.key, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsState = ref.watch(locationProvider(location));
    final locationNotifier = ref.read(locationProvider(location).notifier);
   
    return Stack(
      children: [
        GoogleMap(
          style: mapStyle,

          markers: Set.from(
            locationsState.markers.map(
              (e) => e.copyWith(
                onTapParam: () {
                  showCandyLocationDetails(
                    context,
                    locationCandy: locationsState.candyLocations
                        .where(
                          (element) =>
                              element.id == (int.parse(e.mapsId.value)),
                        )
                        .first,
                    toggleVisited: () {
                      locationNotifier.toggleVisitedLocation(
                        int.parse(e.markerId.value),
                      );
                    },
                  );
                },
              ),
            ),
          ),
         
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(location.$1, location.$2),
            zoom: 16,
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: IconButton.filledTonal(
            onPressed: locationNotifier.getLocations,
            icon: const Icon(Icons.replay_outlined),
          ),
        ),
        Visibility(
          visible: locationsState.isLoading,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withValues(alpha: 0.5),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ],
    );
  }
}
