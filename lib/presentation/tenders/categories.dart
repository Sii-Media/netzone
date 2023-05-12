import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/deals/entities/deals_categories.dart';
import 'package:netzoon/domain/tenders/entities/tender_result.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/deals/view_all_deals.dart';
import 'package:netzoon/presentation/tenders/tenders_categories.dart';

class Categories extends StatefulWidget {
  const Categories(
      {super.key,
      this.dealsCategory,
      required this.category,
      this.tendersCategory});

  final DealsCategory? dealsCategory;
  final TenderResult? tendersCategory;
  final String category;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  // return ViewAllDealsScreen(
                  //   dealsInfoList: dealsCategory.dealList,
                  // );
                  if (widget.category == 'فئات الصفقات') {
                    return ViewAllDealsScreen(
                      dealsInfoList: widget.dealsCategory!.dealList,
                    );
                  } else if (widget.category == 'فئات المناقصات') {
                    return TendersCategoriesScreen(
                      category: widget.tendersCategory?.name ?? '',
                      // tenders: widget.tendersCategory!.tenderList,
                    );
                    // return Container();
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
              widget.dealsCategory != null
                  ? widget.dealsCategory!.categoryName
                  : widget.tendersCategory!.name,
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
