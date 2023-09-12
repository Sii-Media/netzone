import 'package:flutter/material.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

Future<dynamic> authAlert(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate('You_are_not_authenticated'),
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      content: Text(
        AppLocalizations.of(context).translate('please_login_first'),
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
