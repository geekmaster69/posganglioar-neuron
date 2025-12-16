import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:candy_tracker/config/config.dart';
import 'package:candy_tracker/features/auth/presentation/providers/providers.dart';
import 'package:candy_tracker/features/shared/shared.dart';
import 'package:candy_tracker/features/store/presentation/providers/providers.dart';
import 'package:candy_tracker/features/store/presentation/widgets/widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocationState = ref.watch(candiesLocationsProvider);
    final candyLocationsNotifier = ref.watch(candiesLocationsProvider.notifier);
    final size = MediaQuery.of(context).size.height;

    if (userLocationState.isLoading) {
      return const FullScreenLoader();
    }

    ref.listen(candiesLocationsProvider, (previous, next) {
      if (next.message.isNotEmpty) {
        showSnackBar(context, next.message);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          TextButton.icon(
            label: const Text('Salir'),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              context.pushReplacement('/map');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),

        child: GridView.builder(
          itemCount: userLocationState.locations.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: size * 0.4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            final location = userLocationState.locations[index];

            return LocationCard(
              location: location,
              onTap: () => context.push('/candy-location/${location.id}'),
              onLongPress: () {
                showConfirmAction(
                  buttonTitle: 'Eliminar',
                  typeAlert: .destructive,
                  context,
                  confirmAction: () async{
                    await candyLocationsNotifier.deleteCandyLocation(location.id);

                  },
                  title: 'Eliminar ubicación',
                  content:
                      'La ubicación ${location.title} sera eliminada. Esta seguro?',
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/candy-location/-1'),
        label: const Text('Agregar ubicaicón'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
