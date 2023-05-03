import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/categories.dart';
import 'package:netzoon/presentation/categories/factories/factories_categories.dart';
import 'package:netzoon/presentation/categories/free_zoon/category_free_zoon.dart';
import 'package:netzoon/presentation/categories/local_company/local_companies.dart';
import 'package:netzoon/presentation/categories/plans/plans_categories_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/vehicle_list_screen.dart';

class ListOfCategories extends StatelessWidget {
  const ListOfCategories({
    super.key,
    required this.categories,
  });
  final List<Category> categories;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(30)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: InkWell(
                    onTap: () {
                      if (categories[index].name == 'الشركات المحلية') {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const GovernmentalCompanies();
                        }));
                      } else if (categories[index].name ==
                          'شركات المناطق الحرة') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const CategoriesFreeZone(
                                type: '',
                              );
                            },
                          ),
                        );
                      } else if (categories[index].name == 'الجمارك') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const CategoriesFreeZone(
                                type: 'customs',
                              );
                            },
                          ),
                        );
                      } else if (categories[index].name == 'مؤسسات حكومية') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const CategoriesFreeZone(
                                type: 'government',
                              );
                            },
                          ),
                        );
                      } else if (categories[index].name == 'المصانع') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const FactoriesCategoryScreen();
                            },
                          ),
                        );
                      } else if (categories[index].name == 'طائرات مدنية') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const PlansCategoriesScreen();
                            },
                          ),
                        );
                      } else if (categories[index].name == 'سيارات') {
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
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 151,
                              spreadRadius: 300,
                              offset: Offset(10, 30))
                        ],
                      ),
                      height: 300.h,
                      child: Stack(
                        children: [
                          Image.asset(
                            categories[index].url,
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height,
                          ),
                          // CachedNetworkImage(
                          //   imageUrl: categories[index].url,
                          //   fit: BoxFit.fill,
                          //   height: MediaQuery.of(context).size.height,
                          // ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 35.h,
                              color: AppColor.backgroundColor.withOpacity(0.8),
                              alignment: Alignment.center,
                              child: Text(
                                textAlign: TextAlign.center,
                                categories[index].name,
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
