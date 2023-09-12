import 'package:flutter/material.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/services/stripe_backend_service.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeTestScreen extends StatefulWidget {
  const StripeTestScreen({super.key});

  @override
  State<StripeTestScreen> createState() => _StripeTestScreenState();
}

class _StripeTestScreenState extends State<StripeTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            ProgressDialog pd = ProgressDialog(context: context);
            pd.show(
              max: 100,
              msg: 'please wait...',
              progressBgColor: AppColor.backgroundColor,
            );
            try {
              print('1');
              CreateAccountResponse response =
                  await StripeBackendService.createSellerAccount();
              print('11');
              pd.close();
              print('111');
              final Uri url = Uri.parse(
                response.url,
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch';
              }
            } catch (e) {
              pd.close();
            }
          },
          child: const Text('gooo'),
        ),
      ),
    );
  }
}
