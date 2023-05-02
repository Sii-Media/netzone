import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/data/tenders_categories.dart';
import 'package:netzoon/presentation/deals/view_all_deals.dart';

class TendersCategoriesScreen extends StatefulWidget {
  const TendersCategoriesScreen({super.key});

  @override
  State<TendersCategoriesScreen> createState() =>
      _TendersCategoriesScreenState();
}

class _TendersCategoriesScreenState extends State<TendersCategoriesScreen> {
  final tendersCategoryList = tendersCategrories;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BackgroundWidget(
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "فئات المناقصات",
                    style: TextStyle(fontSize: 18.sp, color: Colors.black),
                  ),
                ),
                tendersCategory(name: 'من الأقل سعراً'),
                SizedBox(
                  height: 20.h,
                ),
                tendersCategory(name: 'من الأعلى سعراً'),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Center tendersCategory({required String name}) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ViewAllDealsScreen();
                  },
                ),
              );
            },
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 60.h,
              width: 200.w,
              color: AppColor.backgroundColor,
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 17.sp,
                      color: AppColor.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )),
      ),
    );
  }
}