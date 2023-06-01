import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_localizations.dart';
import '../constant/colors.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    required this.onPressed,
    super.key,
  });
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).translate('no_items'),
            style: TextStyle(
              color: AppColor.backgroundColor,
              fontSize: 22.sp,
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.replay_outlined),
          ),
        ],
      ),
    );
  }
}
