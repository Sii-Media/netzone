import 'package:cached_network_image/cached_network_image.dart';
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
        margin: const EdgeInsets.only(bottom: 80),
        child: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2.h,
            crossAxisSpacing: 16.0.w,
            mainAxisSpacing: 16.0.h,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return SubSectionsScreen(
                      filter: filter,
                      category: items[index].name,
                    );
                  }),
                );
              },
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CachedNetworkImage(
                        maxHeightDiskCache: 400,
                        maxWidthDiskCache: 400,
                        imageUrl: items[index].imageUrl,
                        fit: BoxFit.contain,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70.0, vertical: 50),
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            color: AppColor.backgroundColor,

                            // strokeWidth: 10,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColor.backgroundColor.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate(items[index].name),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/* ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: CategoriesEcommerce(
                          item: items[index], filter: filter),
                    ),
                  ),
                ),
              ],
            );
          },
        ),*/
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
