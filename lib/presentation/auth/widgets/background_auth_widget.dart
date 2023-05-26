import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class BackgroundAuthWidget extends StatelessWidget {
  final Widget widget;
  final String title;
  final double n;
  final double topTitle;
  final double topWidget;
  final double topBack;
  final double topLogo;
  final Function()? onTap;

  BackgroundAuthWidget(
      {Key? key,
      required this.widget,
      required this.title,
      required this.n,
      required this.topTitle,
      required this.topWidget,
      required this.topBack,
      required this.onTap,
      required this.topLogo})
      : super(key: key);
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
                height: MediaQuery.of(context).size.height * n,
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
              height: MediaQuery.of(context).size.height * topLogo,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200.w,
                    height: 130.h,
                    padding: const EdgeInsets.only(left: 0, right: 5),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(top: topWidget.h, right: 0, left: 0, child: widget),
            Positioned(
              top: topTitle.h,
              right: 0,
              left: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0).r,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 25.sp, color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 40.h,
                // left: 8.w,
                // right: 8.w,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: onTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          color: Colors.white,
                          Icons.arrow_back,
                          size: 20.h,
                          weight: 20.w,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('back'),
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
