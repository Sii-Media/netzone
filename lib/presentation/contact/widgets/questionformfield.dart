import 'package:flutter/material.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class QuestionFormField extends StatelessWidget {
  const QuestionFormField({
    super.key,
    required this.textController,
    this.hintText,
    this.maxLines,
    this.onChanged,
    this.validator,
  });

  final TextEditingController textController;
  final String? hintText;
  final int? maxLines;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      controller: textController,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: AppColor.backgroundColor),
        hintText: hintText,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5, horizontal: 10).flipped,
      ),
      onChanged: onChanged,
      textInputAction: TextInputAction.done,
      validator: validator,
    );
  }
}
