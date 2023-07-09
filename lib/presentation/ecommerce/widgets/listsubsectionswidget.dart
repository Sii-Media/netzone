import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../core/helpers/share_image_function.dart';

class ListSubSectionsWidget extends StatelessWidget {
  const ListSubSectionsWidget(
      {super.key, required this.deviceList, this.department, this.category});
  final CategoryProducts deviceList;
  final String? department;
  final String? category;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ProductDetailScreen(
                item: deviceList.id,
              );
            },
          ),
        );
      },
      child: Card(
        elevation: 3,
        child: SizedBox(
          height: 230.h,
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.002),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: deviceList.imageUrl,
                      height: 120.h,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 30.h,
                      child: Text(
                        deviceList.name,
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 4.0),
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 17.sp,
                                          color: AppColor.backgroundColor),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '${deviceList.price}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              decoration: deviceList
                                                          .discountPercentage !=
                                                      null
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            )),
                                        TextSpan(
                                          text: '\$',
                                          style: TextStyle(
                                              color: AppColor.backgroundColor,
                                              fontSize: 10.sp),
                                        )
                                      ]),
                                ),

                                // Text(
                                //   'AED ${deviceList.price}',
                                //   style: TextStyle(
                                //       color: AppColor.backgroundColor,
                                //       fontWeight: FontWeight.w700,
                                //       fontSize: 18,
                                //       decoration:
                                //           deviceList.discountPercentage != null
                                //               ? TextDecoration.lineThrough
                                //               : TextDecoration.none),
                                // ),
                                GestureDetector(
                                  onTap: () async {
                                    await shareImageWithDescription(
                                      imageUrl: deviceList.imageUrl,
                                      description: deviceList.name,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.share,
                                    color: AppColor.backgroundColor,
                                  ),
                                ),
                              ],
                            ),
                            deviceList.discountPercentage != null
                                ? RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            color: AppColor.backgroundColor),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  '${deviceList.priceAfterDiscount}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              )),
                                          TextSpan(
                                            text: '\$ ',
                                            style: TextStyle(
                                                color: AppColor.backgroundColor,
                                                fontSize: 10.sp),
                                          ),
                                          TextSpan(
                                            text:
                                                '  ${deviceList.discountPercentage?.round().toString()}% ${AppLocalizations.of(context).translate('OFF')}',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.sp),
                                          )
                                        ]),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                deviceList.condition != null
                    ? Positioned(
                        top: 3,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: deviceList.condition == 'new'
                                ? Colors.red
                                : Colors.yellow,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8)),
                          ),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate(deviceList.condition.toString()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
