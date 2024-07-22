import 'package:flutter/material.dart';

import '../../utils/app_localizations.dart';
import '../constant/colors.dart';

Future<bool> showSubmitAdsPay({
  required BuildContext context,
  required double totalPrice,
}) async {
  return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context).translate('service_fee'),
                style: const TextStyle(
                    color: AppColor.backgroundColor,
                    fontWeight: FontWeight.w700),
              ),
              content: Text(
                '${AppLocalizations.of(context).translate('you_should_pay')} $totalPrice',
                style: const TextStyle(
                  color: AppColor.backgroundColor,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('cancel'),
                    style: const TextStyle(color: AppColor.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('submit'),
                    style: const TextStyle(color: AppColor.backgroundColor),
                  ),
                ),
              ],
            );
          }) ??
      false;
}
