import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          fixedSize: MaterialStatePropertyAll(
            Size.fromWidth(130.w),
          ),
          side: MaterialStateProperty.all(const BorderSide(
            color: AppColor.backgroundColor,
            width: 2,
          ))),
      child: Text(
        AppLocalizations.of(context).translate('price_sug'),
        style: TextStyle(
          color: AppColor.backgroundColor,
          fontSize: 11.sp,
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
