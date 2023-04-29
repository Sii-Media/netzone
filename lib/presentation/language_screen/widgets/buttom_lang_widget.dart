import 'package:flutter/material.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class ButtonLangWidget extends StatelessWidget {
  final String textButton;
  final void Function()? onPressed;
  const ButtonLangWidget({Key? key, required this.textButton, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      width: double.infinity,
      child: MaterialButton(
        color: AppColor.primaryColor,
        textColor: Colors.white,
        onPressed: onPressed,
        child: Text(textButton,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
