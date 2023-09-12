import 'package:flutter/material.dart';

Future<dynamic> soonAlert(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Soon ...',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      content: const Text(
        'soon >>>',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
