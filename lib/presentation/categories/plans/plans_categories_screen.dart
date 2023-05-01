import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/vehicle_list_screen.dart';

class PlansCategoriesScreen extends StatelessWidget {
  const PlansCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const VehicleListScreen(
                              type: 'plans',
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 60.h,
                      width: double.infinity,
                      color: AppColor.backgroundColor,
                      child: Text(
                        'جديدة',
                        style:
                            TextStyle(fontSize: 15.sp, color: AppColor.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const VehicleListScreen(
                              type: 'plans',
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 60.h,
                      width: double.infinity,
                      color: AppColor.backgroundColor,
                      child: Text(
                        'مستعملة',
                        style:
                            TextStyle(fontSize: 15.sp, color: AppColor.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
