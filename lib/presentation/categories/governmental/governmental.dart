import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/governmental.dart';
import 'package:netzoon/presentation/categories/governmental/govermental_details.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class GovernmentInstitutionScreen extends StatelessWidget {
  const GovernmentInstitutionScreen({
    super.key,
    required this.government,
  });
  final Governmental government;
  @override
  Widget build(BuildContext context) {
    final TextEditingController search = TextEditingController();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30,
                decoration:
                    const BoxDecoration(color: AppColor.backgroundColor),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/00.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 135.w,
                    height: 130.h,
                    padding: const EdgeInsets.only(left: 0, right: 5),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: search,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.white,
                          prefixIcon: InkWell(
                              child: const Icon(Icons.search), onTap: () {}),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          hintText: AppLocalizations.of(context)
                              .translate('search in netzoon'),
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(
                            fontSize: 8.sp,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 150.h,
              child: Center(
                child: Text(
                  AppLocalizations.of(context).translate(government.name),
                  style: TextStyle(fontSize: 22.sp, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              top: 202.h,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.only(
                    top: 1, bottom: 14, left: 20, right: 20),
                height: MediaQuery.of(context).size.height - 191.h,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.95,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: government.images.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return GovermentalDetailsScreen(
                                  govermentalDetails:
                                      government.govermentalDetails,
                                );
                              }));
                            },
                            child: Card(
                              shadowColor: Colors.grey,
                              child: CachedNetworkImage(
                                imageUrl: government.images[index],
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
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
          ],
        ),
      ),
    );
  }
}
