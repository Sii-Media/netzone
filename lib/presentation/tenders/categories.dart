import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/deals/entities/deals_categories.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
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
                  if (category == 'فئات الصفقات') {
                    return const ViewAllDealsScreen();
                  }
                  return const TendersCategoriesScreen();
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
