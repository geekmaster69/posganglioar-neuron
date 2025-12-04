import 'package:flutter/material.dart';

import 'package:candy_tracker/features/store/domain/domain.dart';

class LocationCard extends StatelessWidget {
  final CandyLocation location;
  final VoidCallback onTap;
  const LocationCard({super.key, required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final double border = 12;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(border),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: _BannerImage(images: location.storeImages),
            ),
            Flexible(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(border),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Text(location.title, style: textStyle.titleMedium),
                      Text(
                        location.description,
                        maxLines: 4,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerImage extends StatelessWidget {
  final List<StoreImage> images;
  const _BannerImage({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Center(child: Text('Sin imagnes'));
    }
    return ClipRRect(
      borderRadius: const BorderRadiusGeometry.vertical(
        top: Radius.circular(12),
      ),
      child: Image.network(
        width: double.maxFinite,
        images.first.url,
        fit: .cover,
        height: double.maxFinite,
      ),
    );
  }
}
