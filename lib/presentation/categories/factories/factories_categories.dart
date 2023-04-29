import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/factories/factories_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/data/factories_categories.dart';

class FactoriesCategoryScreen extends StatelessWidget {
  const FactoriesCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final factories = factoriesCategories;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BackgroundWidget(
            widget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: factories.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return FactoryScreen(
                                  factory: factories[index].factory,
                                );
                              }),
                            );
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.only(right: 5.0, top: 10.0),
                            width: MediaQuery.of(context).size.width,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: AppColor.backgroundColor.withOpacity(0.1),
                              border: const Border(
                                bottom: BorderSide(
                                  color: AppColor.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Text(
                              factories[index].title,
                              style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
