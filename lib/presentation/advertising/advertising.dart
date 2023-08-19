import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/advertising/advertising_details.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/core/widgets/background_two_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class AdvertisingScreen extends StatefulWidget {
  const AdvertisingScreen({
    super.key,
  });

  @override
  State<AdvertisingScreen> createState() => _AdvertisingScreenState();
}

class _AdvertisingScreenState extends State<AdvertisingScreen> {
  final adsBloc = sl<AdsBlocBloc>();
  String? selectedValue;
  double priceMin = 0;
  double priceMax = 1000000;
  @override
  void initState() {
    adsBloc.add(const GetAllAdsEvent());
    super.initState();
  }

  final controller = TextEditingController();
  String? ownerName;
  String? year;
  bool? purchasable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundTwoWidget(
        title: AppLocalizations.of(context).translate('advertiments'),
        selectedValue: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
          });
          if (selectedValue == 'عرض الكل') {
            adsBloc.add(const GetAllAdsEvent());
          } else {
            adsBloc.add(
                GetAdsByType(userAdvertisingType: selectedValue as String));
          }
        },
        widget: RefreshIndicator(
          onRefresh: () async {
            adsBloc.add(const GetAllAdsEvent());
          },
          color: AppColor.white,
          backgroundColor: AppColor.backgroundColor,
          child: BlocBuilder<AdsBlocBloc, AdsBlocState>(
            bloc: adsBloc,
            builder: (context, state) {
              if (state is AdsBlocInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                );
              } else if (state is AdsBlocFailure) {
                final failure = state.message;
                return Center(
                  child: Text(
                    failure,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              } else if (state is AdsBlocSuccess) {
                final filteredAds = state.ads
                    .where((ads) => ads.name
                        .toLowerCase()
                        .contains(controller.text.toLowerCase()))
                    .toList();
                if (state.ads.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).translate('no_items'),
                      style: TextStyle(
                        color: AppColor.backgroundColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return Container(
                  padding: const EdgeInsets.only(bottom: 60).r,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                onChanged: (value) {
                                  // elcDeviceBloc.add(SearchProductsEvent(
                                  //     searchQuery: value));
                                  setState(() {});
                                },
                                style: const TextStyle(color: AppColor.black),
                                decoration: InputDecoration(
                                  // filled: true,
                                  hintText: AppLocalizations.of(context)
                                      .translate('search'),
                                  hintStyle: const TextStyle(
                                      color: AppColor.secondGrey),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 30)
                                      .flipped,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColor
                                            .backgroundColor), //<-- Set border color for focused state
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColor
                                            .backgroundColor), //<-- Set border color for enabled state
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            IconButton(
                              onPressed: () {
                                _showFilterBottomSheet(context);
                              },
                              icon: const Icon(
                                Icons.filter_alt,
                                color: AppColor.backgroundColor,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredAds.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 240.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20).w),
                              child:
                                  Advertising(advertisment: filteredAds[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 10.0),
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) {
      //             return const AddAdsPage();
      //           },
      //         ),
      //       );
      //     },
      //     backgroundColor: AppColor.backgroundColor,
      //     tooltip: 'إضافة إعلان',
      //     child: const Icon(
      //       Icons.add,
      //       size: 30,
      //     ),
      //   ),
      // ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text field to write owner name
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          ownerName = value;
                        });
                      },
                      style: const TextStyle(color: AppColor.white),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: AppLocalizations.of(context)
                            .translate('search_by_owner_name'),
                        hintStyle: const TextStyle(color: AppColor.white),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 30)
                            .flipped,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor
                                  .white), //<-- Set border color for focused state
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .white), //<-- Set border color for enabled state
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Slider range for price
                    Text(
                      '${AppLocalizations.of(context).translate('price')} :',
                      style: const TextStyle(
                        color: AppColor.white,
                      ),
                    ),
                    RangeSlider(
                      values: RangeValues(priceMin, priceMax),
                      min: 0,
                      max: 1000000,
                      onChanged: (RangeValues values) {
                        setState(() {
                          priceMin = values.start;
                          priceMax = values.end;
                        });
                      },
                      activeColor: AppColor.white,
                      divisions: 1000,
                      labels:
                          RangeLabels(priceMin.toString(), priceMax.toString()),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CheckboxListTile(
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('is_purchasable'),
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: 15.sp,
                        ),
                      ),
                      activeColor: AppColor.backgroundColor,
                      value: purchasable,
                      onChanged: (bool? value) {
                        setState(() {
                          purchasable = value ?? false;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          year = value;
                        });
                      },
                      style: const TextStyle(color: AppColor.white),
                      decoration: InputDecoration(
                        filled: true,
                        hintText:
                            AppLocalizations.of(context).translate('year'),
                        hintStyle: const TextStyle(color: AppColor.white),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 30)
                            .flipped,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor
                                  .white), //<-- Set border color for focused state
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .white), //<-- Set border color for enabled state
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          AppColor.white,
                        ),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                      ),
                      onPressed: () {
                        adsBloc.add(GetAllAdsEvent(
                          owner: ownerName,
                          priceMax: priceMax.toInt(),
                          priceMin: priceMin.toInt(),
                          purchasable: purchasable,
                          year: year,
                        ));
                        // Close the bottom sheet after applying filters
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppLocalizations.of(context).translate('apply_filters'),
                        style: const TextStyle(
                            color: AppColor.backgroundColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class Advertising extends StatelessWidget {
  const Advertising({
    Key? key,
    required this.advertisment,
  }) : super(key: key);
  final Advertisement advertisment;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0).w,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          margin: const EdgeInsets.symmetric(vertical: 5).r,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1,
            )
          ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
                child: CachedNetworkImage(
                  imageUrl: advertisment.advertisingImage,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70.0, vertical: 50),
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      color: AppColor.backgroundColor,

                      // strokeWidth: 10,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  // height: MediaQuery.of(context).size.height * 0.14,
                ),
              ),
              Text(
                advertisment.name,
                style: TextStyle(
                    color: AppColor.backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                advertisment.advertisingDescription,
                style: TextStyle(
                  color: AppColor.mainGrey,
                  fontSize: 12.sp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return AdvertismentDetalsScreen(
                        adsId: advertisment.id,
                      );
                    }),
                  );
                },
                child: Container(
                  color: AppColor.backgroundColor,
                  height: 30.h,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate('ads_desc'),
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
