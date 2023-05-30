import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../core/helpers/share_image_function.dart';

class ListSubSectionsWidget extends StatelessWidget {
  const ListSubSectionsWidget({super.key, required this.deviceList});
  final CategoryProducts deviceList;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ProductDetailScreen(
                item: deviceList,
              );
            },
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(size.height * 0.002),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: deviceList.imageUrl,
                height: 120.h,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
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
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${deviceList.price} : ${AppLocalizations.of(context).translate('price')}',
                        style: const TextStyle(
                          color: AppColor.backgroundColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await shareImageWithDescription(
                              imageUrl: deviceList.imageUrl,
                              description: deviceList.name);
                        },
                        child: const Icon(
                          Icons.share,
                          color: AppColor.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
