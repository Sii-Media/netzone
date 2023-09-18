import 'package:flutter/material.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_dialog.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class PriceSuggestionButton extends StatelessWidget {
  const PriceSuggestionButton({
    super.key,
    required this.input,
  });

  final TextEditingController input;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            AppColor.white,
          ),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
          fixedSize: const MaterialStatePropertyAll(
            Size.fromWidth(160),
          ),
          side: MaterialStateProperty.all(const BorderSide(
            color: AppColor.backgroundColor,
            width: 2,
          ))),
      child: Text(
        AppLocalizations.of(context).translate('price_sug'),
        style: const TextStyle(
          color: AppColor.backgroundColor,
          fontSize: 13,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return PriceSuggestionDialog(input: input);
          },
        );
      },
    );
  }
}
