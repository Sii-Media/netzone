import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/vehicle_details.dart';
import 'package:netzoon/presentation/data/cars.dart';
import 'package:netzoon/presentation/data/plans.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key, required this.type});

  final String type;
  @override
  Widget build(BuildContext context) {
    final planslist = plans;
    final carList = cars;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
              bottom: 25,
              left: 3.0,
              right: 3.0,
            ),
            child: ListView.builder(
              itemCount: type == 'plans' ? planslist.length : carList.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return VehicleWidget(
                  plan: type == 'plans' ? planslist[index] : carList[index],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class VehicleWidget extends StatelessWidget {
  const VehicleWidget({
    super.key,
    required this.plan,
  });

  final dynamic plan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return VehicleDetailsScreen(
                  vehicle: plan,
                );
              },
            ),
          );
        },
        child: Card(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: plan.imageUrl,
                    width: 700.w,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan.price,
                      style: TextStyle(
                          color: AppColor.colorOne,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.share,
                          color: AppColor.backgroundColor,
                        ),
                        Icon(
                          Icons.favorite_border,
                          color: AppColor.backgroundColor,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  plan.name,
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  plan.description,
                  style: TextStyle(
                    color: AppColor.secondGrey,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          'كيلومترات :',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          plan.kilometers,
                          style: TextStyle(
                            color: AppColor.secondGrey,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Row(
                      children: [
                        Text(
                          'سنة :',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          plan.year,
                          style: TextStyle(
                            color: AppColor.secondGrey,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColor.secondGrey,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      plan.location,
                      style: TextStyle(
                        color: AppColor.secondGrey,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
