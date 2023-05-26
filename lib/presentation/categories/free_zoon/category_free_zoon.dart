import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/companies_categories.dart';
import 'package:netzoon/presentation/categories/governmental/governmental.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/data/customs.dart';
import 'package:netzoon/presentation/data/freezone.dart';
import 'package:netzoon/presentation/data/governmental.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class CategoriesFreeZone extends StatelessWidget {
  const CategoriesFreeZone({super.key, this.type});

  final String? type;

  @override
  Widget build(BuildContext context) {
    final freezoonlist = freezoon;
    final customsList = customs;
    final governmentList = governmental;
    return Scaffold(
      body: BackgroundWidget(
        widget: SingleChildScrollView(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: freezoonlist.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemBuilder: (BuildContext context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              if (type == 'government') {
                                return GovernmentInstitutionScreen(
                                  government: governmentList[index],
                                );
                              }
                              return CompaniesCategories(
                                companiesList: type == ''
                                    ? freezoonlist[index].freezoonplaces
                                    : customsList[index].freezoonplaces,
                                type: type,
                              );
                            }),
                          );
                          // controllerImp.goToFreeZone(
                          //     FreeZoneNames.fromJson(controller.freeZoneAreas[index])
                          //         .freeZoneNamesId);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: Card(
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      top: 0,
                                      right: 0,
                                      child: CachedNetworkImage(
                                        imageUrl: freezoonlist[index].img,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 50.h,
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: AppColor.backgroundColor,
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate(
                                                    freezoonlist[index].name),
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.white),
                                          ),
                                        ))
                                  ],
                                ),
                              )),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
