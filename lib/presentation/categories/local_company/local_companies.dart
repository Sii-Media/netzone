import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_profile.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:netzoon/presentation/data/local_companies.dart';

class GovernmentalCompanies extends StatefulWidget {
  const GovernmentalCompanies({super.key});

  @override
  State<GovernmentalCompanies> createState() => _GovernmentalCompaniesState();
}

class _GovernmentalCompaniesState extends State<GovernmentalCompanies> {
  final localCompanylist = localCompanies;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: localCompanylist.length,
                    itemBuilder: (BuildContext context, index) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: InkWell(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(builder: (context) {
                            //     return NewsDetails(
                            //       news: news[index],
                            //     );
                            //   }),
                            // );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return LocalCompanyProfileScreen(
                                      localCompany: localCompanylist[index],
                                    );
                                  }),
                                );
                              },
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
                                            imageUrl:
                                                localCompanylist[index].imgUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 50.h,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: AppColor.backgroundColor
                                                .withOpacity(0.8),
                                            child: Center(
                                              child: Text(
                                                localCompanylist[index].name,
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
