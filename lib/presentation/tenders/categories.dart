import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/deals/entities/deals_categories.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/deals/view_all_deals.dart';
import 'package:netzoon/presentation/tenders/tenders_categories.dart';

class Categories extends StatelessWidget {
  const Categories(
      {super.key, required this.dealsCategory, required this.category});

  final DealsCategory dealsCategory;
  final String category;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  if (category == 'فئات الصفقات' &&
                      dealsCategory.dealsCategoryName ==
                          'السيارات، الجديدة و المستخدمة') {
                    return const ViewAllDealsScreen();
                  } else if (category == 'فئات المناقصات' &&
                      dealsCategory.dealsCategoryName ==
                          'السيارات، الجديدة و المستخدمة') {
                    return const TendersCategoriesScreen();
                  } else {
                    return const NoDataWidget();
                  }
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
              dealsCategory.dealsCategoryName,
              style: TextStyle(fontSize: 15.sp, color: AppColor.white),
            ),
          )),
    );
  }
}

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BackgroundWidget(
        widget: Scaffold(
          body: Center(
            child: Text(
              'لا يوجد بيانات الان..',
              style: TextStyle(
                color: AppColor.backgroundColor,
                fontSize: 24.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
