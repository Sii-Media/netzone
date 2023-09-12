import 'package:flutter/material.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

Future<dynamic> notNowAlert(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate('sorry'),
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      content: Text(
        AppLocalizations.of(context).translate('This is not Available now'),
        style: const TextStyle(
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
