import 'dart:io';

import 'package:flutter/material.dart';

class ImagesSlider extends StatelessWidget {
  final List<String> images;
final void Function(String path) onTap;
  const ImagesSlider({super.key, required this.images, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return images.isEmpty
        ? Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported_outlined),
                Text('Sin imagenes'),
              ],
            ),
          )
        : PageView(
            controller: PageController(viewportFraction: 0.9),
            scrollDirection: Axis.horizontal,
            children: images
                .map(
                  (e) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(20),
                        child: Image(
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                          image: e.startsWith('http')
                              ? NetworkImage(e)
                              : FileImage(File(e)),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        child: IconButton.filledTonal(
                          onPressed: () =>  onTap(e),
                          icon: Icon(Icons.delete_outline),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          );
  }
}
