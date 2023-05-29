import 'package:flutter/material.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class PriceSuggestionDialog extends StatelessWidget {
  const PriceSuggestionDialog({
    super.key,
    required this.input,
  });

  final TextEditingController input;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          AppLocalizations.of(context).translate('add_suggestion_price'),
          style: const TextStyle(
            color: AppColor.backgroundColor,
          ),
        ),
        content: TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: input,
          keyboardType: TextInputType.number,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // do something with the input value
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                AppColor.backgroundColor,
              ),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
            ),
            child: Text(AppLocalizations.of(context).translate('send')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close the dialog
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                AppColor.backgroundColor,
              ),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
            ),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
        ],
      ),
    );
  }
}
