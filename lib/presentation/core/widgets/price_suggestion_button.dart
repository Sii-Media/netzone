import 'package:flutter/material.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_dialog.dart';

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
          AppColor.backgroundColor,
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        )),
      ),
      child: const Text('عرض السعر'),
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
