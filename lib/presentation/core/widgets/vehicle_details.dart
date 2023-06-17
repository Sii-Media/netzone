import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/map_to_date.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../helpers/share_image_function.dart';

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key, required this.vehicle});

  final dynamic vehicle;

  @override
  Widget build(BuildContext context) {
    final TextEditingController input = TextEditingController();
    return Scaffold(
      body: BackgroundWidget(
        widget: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.0.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 7,
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: vehicle.imageUrl,
                        width: 700.w,
                        height: 200.h,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${vehicle.price.toString()} \$',
                                  style: TextStyle(
                                      color: AppColor.colorOne,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await shareImageWithDescription(
                                            imageUrl: vehicle.imageUrl,
                                            description: vehicle.description);
                                      },
                                      icon: const Icon(
                                        Icons.share,
                                        color: AppColor.backgroundColor,
                                      ),
                                    ),
                                    // const Icon(
                                    //   Icons.favorite_border,
                                    //   color: AppColor.backgroundColor,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              vehicle.name,
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 22.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 7,
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   AppLocalizations.of(context).translate('details'),
                        //   style: TextStyle(
                        //     color: AppColor.black,
                        //     fontSize: 17.sp,
                        //   ),
                        // ),
                        SizedBox(
                          height: 7.h,
                        ),
                        titleAndInput(
                          title:
                              AppLocalizations.of(context).translate('categ'),
                          input: 'S-line',
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        titleAndInput(
                          title: AppLocalizations.of(context).translate('year'),
                          input: formatDate(vehicle.year),
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        titleAndInput(
                          title: AppLocalizations.of(context)
                              .translate('kilometers'),
                          input: vehicle.kilometers.toString(),
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        titleAndInput(
                          title: AppLocalizations.of(context)
                              .translate('regional_specifications'),
                          input: 'مواصفات خليجية',
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        titleAndInput(
                          title: AppLocalizations.of(context)
                              .translate('guarantee'),
                          input: 'لا ينطبق',
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 7,
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('desc'),
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 17.sp,
                        ),
                      ),
                      Text(
                        vehicle.description,
                        style: TextStyle(
                          color: AppColor.mainGrey,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 110.h,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  AppColor.backgroundColor,
                ),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                )),
                fixedSize: const MaterialStatePropertyAll(
                  Size.fromWidth(200),
                ),
              ),
              child: Text(AppLocalizations.of(context).translate('buy')),
              onPressed: () {},
            ),
            PriceSuggestionButton(input: input),
          ],
        ),
      ),
    );
  }

  Container titleAndInput({
    required String title,
    required String input,
  }) {
    return Container(
      height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColor.black,
                fontSize: 15.sp,
              ),
            ),
            Text(
              input,
              style: TextStyle(
                color: AppColor.mainGrey,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
