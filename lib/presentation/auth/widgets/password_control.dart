import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

typedef PasswordControlValidator = String? Function(String? value);

class PasswordControl extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String hintText;
  final String labelText;
  final PasswordControlValidator? validator;

  const PasswordControl(
      {Key? key,
      this.controller,
      this.textInputAction,
      required this.hintText,
      required this.labelText,
      this.validator})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PasswordControlState createState() => _PasswordControlState();
}

class _PasswordControlState extends State<PasswordControl> {
  final GlobalKey<FormFieldState> _passwordFormFieldKey =
      GlobalKey<FormFieldState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _passwordFormFieldKey,
      controller: widget.controller,
      style: const TextStyle(color: AppColor.black),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        errorMaxLines: 2,
        suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).iconTheme.color,
              size: 15.sp,
            ),
            onPressed: _toggle),
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      validator: widget.validator,
      onChanged: (text) {
        _passwordFormFieldKey.currentState!.validate();
      },
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
