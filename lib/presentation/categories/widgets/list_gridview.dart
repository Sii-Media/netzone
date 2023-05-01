import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/categories.dart';
import 'package:netzoon/presentation/categories/factories/factories_categories.dart';
import 'package:netzoon/presentation/categories/free_zoon/category_free_zoon.dart';
import 'package:netzoon/presentation/categories/local_company/local_companies.dart';
import 'package:netzoon/presentation/categories/plans/plans_categories_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/vehicle_list_screen.dart';
import 'package:netzoon/presentation/data/categories.dart';

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
                const Text(
                  "الفئات",
                  style: TextStyle(fontSize: 25, color: Colors.black),
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
          height: 23.h,
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
          if (category.name == 'الشركات المحلية') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const GovernmentalCompanies();
                },
              ),
            );
          } else if (category.name == 'شركات المناطق الحرة') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const CategoriesFreeZone(
                    type: '',
                  );
                },
              ),
            );
          } else if (category.name == 'الجمارك') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const CategoriesFreeZone(
                    type: 'customs',
                  );
                },
              ),
            );
          } else if (category.name == 'مؤسسات حكومية') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const CategoriesFreeZone(
                    type: 'government',
                  );
                },
              ),
            );
          } else if (category.name == 'المصانع') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const FactoriesCategoryScreen();
                },
              ),
            );
          } else if (category.name == 'طائرات مدنية') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const PlansCategoriesScreen();
                },
              ),
            );
          } else if (category.name == 'سيارات') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const VehicleListScreen(
                    type: 'cars',
                  );
                },
              ),
            );
          }
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) {
          //     if (category.name == 'الشركات المحلية') {
          //       return const GovernmentalCompanies();
          //     }
          //     return const CategoriesFreeZone();
          //   }),
          // );
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
                category.name,
                style: TextStyle(fontSize: 15.sp, color: AppColor.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
