import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/colors.dart';

class WhatsAppButton extends StatelessWidget {
  final String whatsappNumber;
  const WhatsAppButton({super.key, required this.whatsappNumber});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        launchWhatsApp(whatsappNumber: whatsappNumber);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          AppColor.backgroundColor,
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        )),
        fixedSize: MaterialStatePropertyAll(
          Size.fromWidth(130.w),
        ),
      ),
      child: const Text('WhatsApp'),
    );
  }

  void launchWhatsApp({required String whatsappNumber}) async {
    final Uri whatsapp = Uri.parse('https://wa.me/$whatsappNumber');
    if (await canLaunchUrl(whatsapp)) {
      await launchUrl(whatsapp);
    } else {
      // ignore: avoid_print
      print('Could not launch WhatsApp');
    }
  }
}
