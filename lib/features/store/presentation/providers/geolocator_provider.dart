import 'package:candy_tracker/config/plugins/plugins.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geolocatorProvider = FutureProvider.autoDispose<(double, double)>((
  ref,
) async {
  final position = await GeolocatorPlugin.determinePosition();

  return (position.latitude, position.longitude);
});
