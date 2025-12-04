import 'package:candy_tracker/config/plugins/plugins.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geolocatorProvider = FutureProvider<(double, double)>((ref) async {
  final currentPosition = await GeolocatorPlugin.determinePosition();

  return (currentPosition.latitude, currentPosition.longitude);
});
