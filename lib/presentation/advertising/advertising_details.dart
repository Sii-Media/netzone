import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/presentation/categories/widgets/free_zone_video_widget.dart';
import 'package:netzoon/presentation/categories/widgets/image_free_zone_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../core/helpers/share_image_function.dart';

class AdvertismentDetalsScreen extends StatefulWidget {
  const AdvertismentDetalsScreen({super.key, required this.ads});

  final Advertisement ads;

  @override
  State<AdvertismentDetalsScreen> createState() =>
      _AdvertismentDetalsScreenState();
}

class _AdvertismentDetalsScreenState extends State<AdvertismentDetalsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController input = TextEditingController();

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: BackgroundWidget(
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
                          imageUrl: widget.ads.advertisingImage,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${widget.ads.advertisingPrice} ${AppLocalizations.of(context).translate('AED')}',
                                    style: TextStyle(
                                        color: AppColor.colorOne,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // const Icon(
                                      //   Icons.favorite_border,
                                      //   color: AppColor.backgroundColor,
                                      // ),
                                      IconButton(
                                        onPressed: () async {
                                          await shareImageWithDescription(
                                              imageUrl:
                                                  widget.ads.advertisingImage,
                                              description: widget.ads.name);
                                        },
                                        icon: const Icon(
                                          Icons.share,
                                          color: AppColor.backgroundColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text(
                                widget.ads.name,
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 20.sp,
                                ),
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('num_of_viewers'),
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.0.w,
                                      ),
                                      Text(
                                        widget.ads.advertisingViews == null
                                            ? "0"
                                            : widget.ads.advertisingViews
                                                .toString(),
                                        style: TextStyle(
                                          color: AppColor.backgroundColor,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                          Text(
                            AppLocalizations.of(context).translate('details'),
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 17.sp,
                            ),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          titleAndInput(
                            title: 'categ',
                            input: widget.ads.advertisingType,
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          titleAndInput(
                            title: 'year',
                            input: widget.ads.advertisingYear,
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          titleAndInput(
                            title: 'kilometers',
                            input: '123',
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          titleAndInput(
                            title: 'regional_specifications',
                            input: 'مواصفات خليجية',
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          titleAndInput(
                            title: 'guarantee',
                            input: 'لا ينطبق',
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          titleAndInput(
                            title: 'الموقع',
                            input: widget.ads.advertisingLocation,
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
                          widget.ads.advertisingDescription,
                          style: TextStyle(
                            color: AppColor.mainGrey,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
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
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context).translate('images')} :',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 17.sp,
                          ),
                        ),
                        widget.ads.advertisingImageList?.isNotEmpty == true
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    widget.ads.advertisingImageList?.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.94),
                                itemBuilder: (BuildContext context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: ListOfPictures(
                                      img: widget
                                          .ads.advertisingImageList![index],
                                    ),
                                  );
                                })
                            : GestureDetector(
                                onTap: () {},
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('no_images'),
                                  style: TextStyle(
                                    color: AppColor.mainGrey,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                      ],
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
                    child: widget.ads.advertisingVedio != null &&
                            widget.ads.advertisingVedio != ''
                        ? VideoFreeZoneWidget(
                            title:
                                "${AppLocalizations.of(context).translate('vedio')}  : ",
                            vediourl: widget.ads.advertisingVedio ?? '',
                          )
                        : Text(
                            AppLocalizations.of(context).translate('no_vedio'),
                            style: TextStyle(
                              color: AppColor.mainGrey,
                              fontSize: 15.sp,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 120.h,
                  ),
                ],
              ),
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
              child:
                  Text(AppLocalizations.of(context).translate('شراء المنتج')),
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
              AppLocalizations.of(context).translate(title),
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
