import 'package:cached_network_image/cached_network_image.dart';
import 'package:candy_tracker/features/map/domain/domain.dart';
import 'package:candy_tracker/features/map/presentation/providers/is_visited_location_provider.dart';
import 'package:candy_tracker/features/map/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showCandyLocationDetails(
  BuildContext context, {
  required MapCandyLocation locationCandy,
  required VoidCallback toggleVisited,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      final textStyle = Theme.of(context).textTheme;
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
        
          children: [
            const SizedBox(width: double.maxFinite),

            _ImageCarousel(locationCandy.storeImages),

            Text(locationCandy.title, style: textStyle.titleLarge),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                locationCandy.description,
                style: textStyle.bodyLarge,
              ),
            ),

            Text('Promocines del lugar', style: textStyle.titleLarge),

            if(locationCandy.promotions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Sin promociones'),
            ),

            ...locationCandy.promotions.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text('📢❗🚨 $e'),
              ),
            ),

            Text('Dulces restantes', style: textStyle.headlineSmall,),
            CandyRemaining(remaining: locationCandy.quantity),

            _VisitedButton(locationCandy.id, onTap: toggleVisited),
            const SizedBox(height: 40,)
          ],
        ),
      );
    },
  );
}

class _VisitedButton extends ConsumerWidget {
  final int candyId;
  final VoidCallback onTap;
  const _VisitedButton(this.candyId, {required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisitedState$ = ref.watch(isVisitedLocationProvider(candyId));
    return isVisitedState$.when(
      data: (data) => SizedBox(
        width: double.maxFinite,
        child: FilledButton.icon(
          onPressed: data
              ? null
              : () {
                  onTap();
                  ref.invalidate(isVisitedLocationProvider(candyId));
                },
          label: const Text('Visitado!!!'),
          icon: Icon(data ? Icons.check_circle_outline : Icons.circle_outlined),
        ),
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  final List<String> images;
  const _ImageCarousel(this.images);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.3,
      child: images.isEmpty
          ? Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    size: size.height * 0.15,
                  ),
                  const Text('Sin imagenes', style: TextStyle(fontSize: 22)),
                ],
              ),
            )
          : CarouselView(
              controller: CarouselController(),
              itemExtent: size.width * 0.7,

              children: images
                  .map(
                    (e) => CachedNetworkImage(
                      imageUrl: e,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Text(error.toString()),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
