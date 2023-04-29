import 'package:flutter/material.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class TextSignup extends StatelessWidget {
  final String text;
  const TextSignup({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: AppColor.backgroundColor),
    );
  }
}
