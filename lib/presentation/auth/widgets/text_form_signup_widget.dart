import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormSignupWidget extends StatelessWidget {
  final TextEditingController? myController;
  final String? Function(String?)? valid;
  final bool isNumber;
  final bool password;
  final void Function()? onTapIcon;

  const TextFormSignupWidget(
      {Key? key,
      this.myController,
      this.valid,
      required this.isNumber,
      required this.password,
      this.onTapIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10).r,
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: valid,
        controller: myController,
        decoration: InputDecoration(
          filled: true,
          //<-- SEE HERE
          fillColor: Colors.green.withOpacity(0.1),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 3).flipped,
          suffixIcon: password
              ? InkWell(
                  onTap: onTapIcon, child: const Icon(Icons.remove_red_eye))
              : const SizedBox(
                  height: 0,
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
