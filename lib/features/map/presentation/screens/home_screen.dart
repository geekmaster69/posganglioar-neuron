import 'package:candy_tracker/features/map/presentation/view/views.dart';
import 'package:candy_tracker/features/shared/shared.dart';
import 'package:candy_tracker/features/store/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final geolocatorState$ = ref.watch(geolocatorProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Candy tracker')),
      body: geolocatorState$.when(
        data: (location) => IndexedStack(
          index: _selectedIndex,
          children: [
            CandyMapView(location: location),
            PlacesView(location: location),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.map_outlined),
            label: 'Mapa',
            selectedIcon: Icon(Icons.map),
          ),
          const NavigationDestination(
            icon: Icon(Icons.store_mall_directory_outlined),
            selectedIcon: Icon(Icons.store),
            label: 'Lugares',
          ),
          // const NavigationDestination(
          //   icon: Icon(Icons.person_outline),
          //   label: 'Perfil',
          //   selectedIcon: Icon(Icons.person),
          // ),
        ],

        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),

      drawer: const SideMenu(),
    );
  }
}
