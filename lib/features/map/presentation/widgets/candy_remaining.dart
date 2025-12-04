import 'package:flutter/material.dart';

class CandyRemaining extends StatelessWidget {
  final int remaining;
  const CandyRemaining({super.key, required this.remaining});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final border = BorderRadius.circular(12);
    final double imageSize = 100;

    return remaining == 0
        ? Column(
          children: [
            const Text('Sin dulces', style: TextStyle(fontSize: 32),),
            Image.asset('assets/images/ghost.png'),
          ],
        )
        : Stack(
            children: [
              Container(
                height: 50,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: border,
                  border: Border.all(color: Colors.white70),
                ),
              ),
              Container(
                height: 50,
                width: (size.width * remaining) / 100,

                decoration: BoxDecoration(
                  borderRadius: border,
                  color: _selectCOlor(remaining),
                ),
              ),

              Image.asset(
                'assets/images/caldero.png',
                height: imageSize,
                width: imageSize,
              ),
            ],
          );
  }
}

Color _selectCOlor(int value) {
  if (value > 50) {
    return Colors.green;
  }

  if (value == 50) {
    return Colors.orange;
  }

  return Colors.red;
}
