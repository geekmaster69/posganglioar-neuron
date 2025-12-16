import 'package:flutter/material.dart';

enum TypeAlert { warning, destructive, affirmative }

Future<void> showConfirmAction(
  BuildContext context, {
  required VoidCallback confirmAction,
  required String title,
  required String buttonTitle,
  required String content,
  TypeAlert typeAlert = .affirmative,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: Icon(_selectIcon(typeAlert), color: _selectColor(typeAlert)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cnacelar'),
          ),

          FilledButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: _selectColor(typeAlert),
            ),
            onPressed: () {
              confirmAction();
              Navigator.pop(context);
            },
            child: Text(
              buttonTitle,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

Color _selectColor(TypeAlert typeAlert) {
  switch (typeAlert) {
    case .affirmative:
      return Colors.green.shade800;
    case .warning:
      return Colors.amber.shade800;
    default:
      return Colors.red.shade800;
  }
}

IconData _selectIcon(TypeAlert typeAlert) {
  switch (typeAlert) {
    case .affirmative:
      return Icons.check;
    case .warning:
      return Icons.warning;
    default:
      return Icons.delete_outline;
  }
}
