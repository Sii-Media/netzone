import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormAuthWidget extends StatelessWidget {
  final String hintText;
  final String labelText;
  final IconData iconData;
  // final TextEditingController? myController;
  final String? Function(String?)? valid;
  final bool isNumber;
  final bool password;
  final bool? obscureText;
  final void Function()? onTapIcon;

  const TextFormAuthWidget(
      {Key? key,
      this.obscureText,
      this.onTapIcon,
      required this.hintText,
      required this.labelText,
      required this.iconData,
      // required this.myController,
      required this.valid,
      required this.isNumber,
      required this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 25,
      ).r,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: valid,
        // controller: myController,
        obscureText: obscureText == null || obscureText == false ? false : true,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 30).flipped,
          // label: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: 9),
          //     child: Text(labelText)),
          suffixIcon: password
              ? InkWell(
                  onTap: onTapIcon, child: const Icon(Icons.remove_red_eye))
              : const SizedBox(
                  height: 0,
                ),
          counterStyle: const TextStyle(color: Colors.white),
          labelStyle: const TextStyle(color: Colors.white),
          suffixStyle: const TextStyle(color: Colors.white),
          floatingLabelStyle: const TextStyle(color: Colors.white),
          errorStyle: const TextStyle(color: Colors.white),
          helperStyle: const TextStyle(color: Colors.white),
          prefixStyle: const TextStyle(color: Colors.white),
          prefixIconColor: Colors.white,
          suffixIconColor: Colors.white,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(30),
          // ),
          icon: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
