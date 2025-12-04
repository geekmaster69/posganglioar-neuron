import 'package:flutter/material.dart';

class FullScreenError extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onTap;
  const FullScreenError({super.key, required this.errorMessage, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: colors.error),
          Text(errorMessage),
          if (onTap != null)
            OutlinedButton(onPressed: onTap, child: Text('Volver a intentar')),
        ],
      ),
    );
  }
}
