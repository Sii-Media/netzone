import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/vehicle_list_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class PlansCategoriesScreen extends StatelessWidget {
  const PlansCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            category: 'plans',
                            type: 'new',
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 60.h,
                    width: double.infinity,
                    color: AppColor.backgroundColor,
                    child: Text(
                      AppLocalizations.of(context).translate('new'),
                      style: TextStyle(fontSize: 15.sp, color: AppColor.white),
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
                            category: 'plans',
                            type: 'used',
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 60.h,
                    width: double.infinity,
                    color: AppColor.backgroundColor,
                    child: Text(
                      AppLocalizations.of(context).translate('Used'),
                      style: TextStyle(fontSize: 15.sp, color: AppColor.white),
                    ),
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
