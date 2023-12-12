import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constant/colors.dart';
import '../../core/widgets/phone_call_button.dart';
import '../../utils/app_localizations.dart';

Widget infoListWidget({
  required BuildContext context,
  String? username,
  String? description,
  required String firstMobile,
  required String email,
  String? bio,
  String? address,
  String? website,
  String? link,
  bool? deliverable,
  String? deliveryType,
  int? deliveryCarsNum,
  int? deliveryMotorsNum,
  bool? isThereFoodsDelivery,
  bool? isThereWarehouse,
}) {
  return ListView(
    children: [
      Column(
        children: [
          titleAndInput(
              title: AppLocalizations.of(context).translate('company_name'),
              input: username ?? ''),
          description != null
              ? titleAndInput(
                  title: AppLocalizations.of(context).translate('desc'),
                  input: description)
              : const SizedBox(),
          // titleAndInput(
          //     title: AppLocalizations.of(context).translate('mobile'),
          //     input: firstMobile),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // height: 40.h,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.4),
                    width: 1.0,
                  ),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('mobile'),
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(
                      width: 190.w,
                      child: PhoneCallWidget(
                        phonePath: firstMobile,
                        title: firstMobile,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          titleAndInput(
              title: AppLocalizations.of(context).translate('email'),
              input: email),
          bio != null && bio != ''
              ? titleAndInput(
                  title: AppLocalizations.of(context).translate('Bio'),
                  input: bio)
              : const SizedBox(),
          address != null && address != ''
              ? titleAndInput(
                  title: AppLocalizations.of(context).translate('address'),
                  input: address)
              : const SizedBox(),
          website != null && website != ''
              ?
              // ? titleAndInput(
              //     title: AppLocalizations.of(context).translate('website'),
              //     input: website)
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // height: 40.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.4),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('website'),
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(
                            width: 180.w,
                            child: GestureDetector(
                              onTap: () async {
                                final Uri url = Uri(
                                  scheme: 'https',
                                  path: website,
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  // Handle the error
                                  print('Could not launch $url');
                                }
                              },
                              child: Text(
                                website,
                                style: TextStyle(
                                  color: AppColor.mainGrey,
                                  fontSize: 15.sp,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ), // Link(
                          //   uri: Uri.parse(
                          //     website,
                          //   ),
                          //   builder: ((context, followLink) => SizedBox(
                          //         width: 190.w,
                          //         child: GestureDetector(
                          //           onTap: followLink,
                          //           child: Text(
                          //             website,
                          //             style: TextStyle(
                          //               color: AppColor.mainGrey,
                          //               fontSize: 15.sp,
                          //               decoration: TextDecoration.underline,
                          //             ),
                          //           ),
                          //         ),
                          //       )),
                          // ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          link != null && link != ''
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // height: 40.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.4),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('link'),
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(
                            width: 180.w,
                            child: GestureDetector(
                              onTap: () async {
                                final Uri url = Uri(
                                  scheme: 'https',
                                  path: link,
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  // Handle the error
                                  print('Could not launch $url');
                                }
                              },
                              child: Text(
                                link,
                                style: TextStyle(
                                  color: AppColor.mainGrey,
                                  fontSize: 15.sp,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              // ? titleAndInput(
              //     title: AppLocalizations.of(context).translate('link'),
              //     input: link)
              : const SizedBox(),
          // deliverable != null
          //     ? titleAndInput(
          //         title: AppLocalizations.of(context)
          //             .translate('Is there delivery'),
          //         input: deliverable
          //             ? AppLocalizations.of(context).translate('Yes')
          //             : AppLocalizations.of(context).translate('No'),
          //       )
          //     : const SizedBox(),
          deliveryType != null
              ? titleAndInput(
                  title:
                      AppLocalizations.of(context).translate('delivery_type'),
                  input: deliveryType,
                )
              : const SizedBox(),
          deliveryCarsNum != null
              ? titleAndInput(
                  title:
                      AppLocalizations.of(context).translate('deliveryCarsNum'),
                  input: deliveryCarsNum.toString(),
                )
              : const SizedBox(),
          deliveryMotorsNum != null
              ? titleAndInput(
                  title: AppLocalizations.of(context)
                      .translate('deliveryMotorsNum'),
                  input: deliveryMotorsNum.toString(),
                )
              : const SizedBox(),
          isThereFoodsDelivery != null
              ? titleAndInput(
                  title: AppLocalizations.of(context)
                      .translate('is_there_food_delivery'),
                  input: isThereFoodsDelivery
                      ? AppLocalizations.of(context).translate('Yes')
                      : AppLocalizations.of(context).translate('No'),
                )
              : const SizedBox(),
          isThereWarehouse != null
              ? titleAndInput(
                  title: AppLocalizations.of(context)
                      .translate('is_there_warehouse'),
                  input: isThereWarehouse
                      ? AppLocalizations.of(context).translate('Yes')
                      : AppLocalizations.of(context).translate('No'),
                )
              : const SizedBox(),
        ],
      ),
    ],
  );
}

Padding titleAndInput({required String title, required String input}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      // height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColor.black,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(
              width: 190.w,
              child: Text(
                input,
                style: TextStyle(
                  color: AppColor.mainGrey,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
