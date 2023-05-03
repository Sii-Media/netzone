import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/data/deals_categories.dart';
import 'package:netzoon/presentation/data/tenders_categories.dart';
import 'package:netzoon/presentation/tenders/categories.dart';

class DealsCategoriesScreen extends StatefulWidget {
  const DealsCategoriesScreen({super.key, required this.title});

  final String title;

  @override
  State<DealsCategoriesScreen> createState() => _DealsCategoriesScreenState();
}

class _DealsCategoriesScreenState extends State<DealsCategoriesScreen> {
  List<dynamic> list = [];

  @override
  void initState() {
    if (widget.title == 'فئات الصفقات') {
      list = dealsCategories;
    } else {
      list = tendersCategrories;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final dealsCategoryList = dealsCategories;
    // final tendersCategoryList = tendersCategrories;
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
                    widget.title,
                    style: TextStyle(fontSize: 20.sp, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0.h),
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 8),
                            child: widget.title == 'فئات الصفقات'
                                ? Categories(
                                    dealsCategory: list[index],
                                    category: widget.title,
                                  )
                                : Categories(
                                    tendersCategory: list[index],
                                    category: widget.title,
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
