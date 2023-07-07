import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/categories.dart';
import 'package:netzoon/presentation/categories/customs_screen/customs_category.dart';
import 'package:netzoon/presentation/categories/factories/factories_categories.dart';
import 'package:netzoon/presentation/categories/free_zoon/category_free_zoon.dart';
import 'package:netzoon/presentation/categories/governmental/govermental_category_screen.dart';
import 'package:netzoon/presentation/categories/local_company/local_companies.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/data/categories.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../users/screens/users_list_screen.dart';
import '../vehicles/screens/vehicles_companies_screen.dart';

class ListGridView extends StatelessWidget {
  const ListGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = cat;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            // height: 70.sp,
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).translate('category'),
                  style: const TextStyle(fontSize: 25, color: Colors.black),
                ),
                SizedBox(
                  width: 10.w,
                ),
                const Icon(
                  Icons.arrow_downward_sharp,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: GridCategory(category: categories[index]),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 90.h,
        ),
      ],
    );
  }
}

class GridCategory extends StatelessWidget {
  const GridCategory({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: () {
          if (category.name == 'local_companies') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const GovernmentalCompanies();
                },
              ),
            );
          } else if (category.name == 'free_zone_companies') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const CategoriesFreeZone();
                },
              ),
            );
          } else if (category.name == 'customs') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const CustomsCategoryScreen();
                },
              ),
            );
          } else if (category.name == 'government_institutions') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const GovermentalCategoryScreen();
                },
              ),
            );
          } else if (category.name == 'factories') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const FactoriesCategoryScreen();
                },
              ),
            );
          } else if (category.name == 'civil_aircraft') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const VehiclesCompaniesScreen(
                    type: 'planes',
                  );
                },
              ),
            );
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return const PlansCategoriesScreen();
            //     },
            //   ),
            // );
          } else if (category.name == 'cars') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const VehiclesCompaniesScreen(
                    type: 'cars',
                  );
                },
              ),
            );
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return const VehicleListScreen(
            //         category: 'cars',
            //       );
            //     },
            //   ),
            // );
          } else if (category.name == 'users') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const UsersListScreen();
                },
              ),
            );
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              category.url,
              fit: BoxFit.fitHeight,
              height: 160.h,
            ),
            Container(
              height: 50.h,
              width: double.infinity,
              color: AppColor.backgroundColor.withOpacity(0.8),
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context).translate(category.name),
                style: TextStyle(fontSize: 15.sp, color: AppColor.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
