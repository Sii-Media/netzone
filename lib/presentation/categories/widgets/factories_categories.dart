import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

import '../factories/factory_profile_screen.dart';

class ViewFactoriesWidget extends StatelessWidget {
  const ViewFactoriesWidget({super.key, required this.factory});
  final List<UserInfo> factory;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0.h, top: 20.0.h),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: factory.length,
        itemBuilder: (context, index) {
          return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: FactoriesCategories(
                  factory: factory[index],
                ),
              ));
        },
      ),
    );
  }
}

class FactoriesCategories extends StatelessWidget {
  const FactoriesCategories({super.key, required this.factory});
  final UserInfo factory;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return FactoryProfileScreen(user: factory);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: SizedBox(
            height: 210.h,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: CachedNetworkImage(
                    imageUrl: factory.profilePhoto ?? '',
                    fit: BoxFit.fill,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70.0, vertical: 50),
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: AppColor.backgroundColor,

                        // strokeWidth: 10,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    height: 60.h,
                    width: MediaQuery.of(context).size.width,
                    color: AppColor.backgroundColor.withOpacity(0.8),
                    child: Text(
                      factory.username ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
