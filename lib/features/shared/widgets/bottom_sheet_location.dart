import 'package:candy_tracker/features/store/presentation/providers/geolocator_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> showBottomSheetLocation(
  BuildContext context, {
  required void Function(LatLng latLng) selectCenter,
}) {
  return showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return _BottomSheetLocation(selectCenter);
    },
  );
}

class _BottomSheetLocation extends ConsumerStatefulWidget {
  final void Function(LatLng) selectCenter;
  const _BottomSheetLocation(this.selectCenter);

  @override
  ConsumerState<_BottomSheetLocation> createState() =>
      _BottomSheetLocationState();
}

class _BottomSheetLocationState extends ConsumerState<_BottomSheetLocation> {
  LatLng? _center;

  @override
  Widget build(BuildContext context) {
    final geolocatorState$ = ref.watch(geolocatorProvider);

    return geolocatorState$.when(
      data: (data) => SafeArea(
        child: Column(
          children: [
            const ListTile(
              title: Text('Seleccionar ubicación'),
              subtitle: Text('Selecciona dónde darán dulces'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      GoogleMap(
                        myLocationEnabled: true,
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(data.$1, data.$2),
                          zoom: 17,
                        ),
                        onMapCreated: (controller) {
                          _center = LatLng(data.$1, data.$2);
                        },

                        onCameraMove: (position) {
                          _center = position.target;
                        },
                      ),
                      const Positioned.fill(
                        child: Center(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FilledButton(
              onPressed: () async {
                if (_center != null) {
                  widget.selectCenter(_center!);
                  Navigator.pop(context);
                } else {
                  debugPrint('El mapa no está inicializado aún.');
                }
              },
              child: const Text('Guardar ubicación'),
            ),
            // const SizedBox(height: 20,)
          ],
        ),
      ),
      error: (e, _) => Center(child: Text(e.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
