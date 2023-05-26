import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class BackgroundAnotherWidget extends StatelessWidget {
  final Widget widget;

  BackgroundAnotherWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.12,
                decoration:
                    const BoxDecoration(color: AppColor.backgroundColor),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/00.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 135.w,
                    height: 130,
                    padding: const EdgeInsets.only(left: 0, right: 5),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: search,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.white,
                          prefixIcon: InkWell(
                              child: const Icon(Icons.search), onTap: () {}),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          hintText: AppLocalizations.of(context)
                              .translate('search in netzoon'),
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(
                            fontSize: 8.sp,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 60.h,
              right: 0,
              left: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 35.h,
                child: SafeArea(child: widget),
              ),
            )
          ],
        ),
      ),
    );
  }
}
