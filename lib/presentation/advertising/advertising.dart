import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/advertising/add_ads_page.dart';
import 'package:netzoon/presentation/advertising/advertising_details.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/core/widgets/background_two_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class AdvertisingScreen extends StatefulWidget {
  const AdvertisingScreen({super.key, required this.advertisment});

  final List<Advertisement> advertisment;

  @override
  State<AdvertisingScreen> createState() => _AdvertisingScreenState();
}

class _AdvertisingScreenState extends State<AdvertisingScreen> {
  final adsBloc = sl<AdsBlocBloc>();
  String? selectedValue;
  @override
  void initState() {
    adsBloc.add(GetAllAdsEvent());
    super.initState();
  }

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
            adsBloc.add(GetAllAdsEvent());
          } else {
            adsBloc.add(
                GetAdsByType(userAdvertisingType: selectedValue as String));
          }
        },
        widget: RefreshIndicator(
          onRefresh: () async {
            adsBloc.add(GetAllAdsEvent());
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.ads.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 240.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20).w),
                        child: Advertising(advertisment: state.ads[index]),
                      );
                    },
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const AddAdsPage();
                },
              ),
            );
          },
          backgroundColor: AppColor.backgroundColor,
          tooltip: 'إضافة إعلان',
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
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
                  // height: MediaQuery.of(context).size.height * 0.14,
                ),
              ),
              Text(
                advertisment.advertisingTitle,
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
                        ads: advertisment,
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
                      "تفاصيل الإعلان",
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
