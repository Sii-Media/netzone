import 'package:flutter/material.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/colors.dart';

class PhoneCallWidget extends StatelessWidget {
  const PhoneCallWidget({
    super.key,
    required this.phonePath,
  });

  final String phonePath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final Uri url = Uri(
          scheme: 'tel',
          path: phonePath,
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {}
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          AppColor.backgroundColor,
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        )),
        fixedSize: const MaterialStatePropertyAll(
          Size.fromWidth(100),
        ),
      ),
      child: Text(
        AppLocalizations.of(context).translate('call'),
      ),
    );
  }
}
