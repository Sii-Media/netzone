import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/ecommerce/screens/subsection_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class ListCategoriesEcommerce extends StatelessWidget {
  const ListCategoriesEcommerce(
      {super.key, required this.items, required this.filter});
  final List<dynamic> items;
  final String filter;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child:
                      CategoriesEcommerce(item: items[index], filter: filter),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoriesEcommerce extends StatelessWidget {
  const CategoriesEcommerce(
      {super.key, required this.item, required this.filter});

  final DepartmentsCategories item;
  final String filter;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return SubSectionsScreen(
              filter: filter,
              category: item.name,
              // list: item.deviceList,
            );
          }),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Container(
          height: 50.h,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: AppColor.white, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 1,
            )
          ]),
          child: Text(
            AppLocalizations.of(context).translate(item.name),
            style: TextStyle(color: AppColor.black, fontSize: 19.sp),
          ),
        ),
      ),
    );
  }
}
