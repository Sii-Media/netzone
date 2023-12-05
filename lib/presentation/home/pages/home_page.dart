import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/aramex/entities/actual_weight.dart';
import 'package:netzoon/domain/aramex/entities/calculate_rate_input_data.dart';
import 'package:netzoon/domain/aramex/entities/client_info.dart';
import 'package:netzoon/domain/aramex/entities/contact.dart';
import 'package:netzoon/domain/aramex/entities/create_pickup_input_data.dart';
import 'package:netzoon/domain/aramex/entities/label_info.dart';
import 'package:netzoon/domain/aramex/entities/party_address.dart';
import 'package:netzoon/domain/aramex/entities/pickup.dart';
import 'package:netzoon/domain/aramex/entities/pickup_items.dart';
import 'package:netzoon/domain/aramex/entities/rate_shipment_details.dart';
import 'package:netzoon/domain/aramex/entities/shipment_dimensions.dart';
import 'package:netzoon/domain/aramex/entities/transaction.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/advertising/advertising.dart';
import 'package:netzoon/presentation/aramex/blocs/aramex_bloc/aramex_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/categories/local_company/services_by_category_screen.dart';
import 'package:netzoon/presentation/categories/local_company/services_categories_screen.dart';
import 'package:netzoon/presentation/categories/main_categories.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/data/advertisments.dart';
import 'package:netzoon/presentation/data/categories.dart';
import 'package:netzoon/presentation/deals/blocs/dealsItems/deals_items_bloc.dart';
import 'package:netzoon/presentation/deals/blocs/deals_list_widget.dart';
import 'package:netzoon/presentation/deals/deals_screen.dart';
import 'package:netzoon/presentation/home/blocs/elec_devices/elec_devices_bloc.dart';
import 'package:netzoon/presentation/home/widgets/images_slider.dart';
import 'package:netzoon/presentation/home/widgets/list_of_categories.dart';
import 'package:netzoon/presentation/home/widgets/slider_news_widget.dart';
import 'package:netzoon/presentation/home/widgets/title_and_button.dart';
import 'package:netzoon/presentation/news/blocs/news/news_bloc.dart';
import 'package:netzoon/presentation/news/news_screen.dart';
import 'package:netzoon/presentation/tenders/blocs/tendersItem/tenders_item_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/core/constants/constants.dart';
import '../../../data/models/auth/user/user_model.dart';
import '../../advertising/blocs/ads/ads_bloc_bloc.dart';
import '../../categories/real_estate/blocs/real_estate/real_estate_bloc.dart';
import '../../categories/real_estate/screens/real_estate_details_screen.dart';
import '../../categories/real_estate/screens/real_estate_list_screen.dart';
import '../../categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import '../../chat/screens/chat_home_screen.dart';
import '../../core/widgets/no_data_widget.dart';
import '../../core/widgets/on_failure_widget.dart';
import '../widgets/auth_alert.dart';
import '../widgets/build_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final categories = cat;

  // final advertismentList = advertisments;

  final PageController controller = PageController(initialPage: 0);

  final newsBloc = sl<NewsBloc>();
  final adsBloc = sl<AdsBlocBloc>();

  final tenderItemBloc = sl<TendersItemBloc>();
  final dealsItemBloc = sl<DealsItemsBloc>();
  final elcDeviceBloc = sl<ElecDevicesBloc>();
  final deviceBloc = sl<ElecDevicesBloc>();
  final manFashionBloc = sl<ElecDevicesBloc>();
  final womanFashionBloc = sl<ElecDevicesBloc>();
  final foodsBloc = sl<ElecDevicesBloc>();
  final perfumesBloc = sl<ElecDevicesBloc>();
  final watchesBloc = sl<ElecDevicesBloc>();
  final animalBloc = sl<ElecDevicesBloc>();
  final musicBloc = sl<ElecDevicesBloc>();
  final sportBloc = sl<ElecDevicesBloc>();
  final agricultureBloc = sl<ElecDevicesBloc>();
  final otherBloc = sl<ElecDevicesBloc>();
  final planesBloc = sl<VehicleBloc>();
  final carsBloc = sl<VehicleBloc>();
  final realEstateBloc = sl<RealEstateBloc>();
  // late AnimationController _animationController;
  final authBloc = sl<AuthBloc>();

  final aramexBloc = sl<AramexBloc>();

  final servicesBloc = sl<LocalCompanyBloc>();

  int totalUnreadMessageCount = 0;
  void connectToSendbird({required String id}) async {
    await SendbirdChat.connect(id);
  }

  List imgs = [
    {"id": 1, "image": 'assets/images/aramex.png'},
    {"id": 2, "image": 'assets/images/payments.png'},
    {"id": 3, "image": 'assets/images/netzoon_download.png'},
    {"id": 4, "image": 'assets/images/comp.png'}
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  void initState() {
    callApi();
    getTotalUnreadMessages();
    super.initState();
  }

  Future<int> getTotalUnreadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey(SharedPreferencesKeys.user)) {
        return 0;
      }

      final user = UserModel.fromJson(
        json.decode(prefs.getString(SharedPreferencesKeys.user)!)
            as Map<String, dynamic>,
      );
      await SendbirdChat.connect(user.userInfo.username);
      int t = await SendbirdChat.getTotalUnreadMessageCount();

      totalUnreadMessageCount = t;
    } catch (e) {
      // Handle error.
    }
    setState(() {});
    return totalUnreadMessageCount;
  }

  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }

  void callApi() {
    authBloc.add(AuthCheckRequested());
    newsBloc.add(GetAllNewsEvent());
    adsBloc.add(const GetAllAdsEvent());
    // tenderItemBloc.add(const GetTendersItemEvent());
    dealsItemBloc.add(GetDealsItemEvent());
    elcDeviceBloc.add(const GetElcDevicesEvent(department: 'الكترونيات'));
    deviceBloc
        .add(const GetElcDevicesEvent(department: 'أجهزة المنزل والمكتب'));
    manFashionBloc.add(const GetElcDevicesEvent(department: 'موضة رجالية'));
    womanFashionBloc.add(const GetElcDevicesEvent(department: 'موضة نسائية'));
    foodsBloc.add(const GetElcDevicesEvent(department: 'منتجات غذائية'));
    perfumesBloc.add(const GetElcDevicesEvent(department: 'عطور'));
    watchesBloc.add(const GetElcDevicesEvent(department: 'ساعات'));
    animalBloc.add(const GetElcDevicesEvent(department: 'حيوانات'));
    musicBloc.add(const GetElcDevicesEvent(department: 'آلات موسيقية'));
    sportBloc.add(const GetElcDevicesEvent(department: 'أجهزة رياضية'));
    agricultureBloc.add(const GetElcDevicesEvent(department: 'الزراعة'));
    otherBloc.add(const GetElcDevicesEvent(department: 'أخرى'));

    planesBloc.add(const GetAllPlanesEvent());
    carsBloc.add(GetLatestCarByCreatorEvent());
    realEstateBloc.add(GetAllRealEstatesEvent());
    servicesBloc.add(GetServicesCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: RefreshIndicator(
        onRefresh: () async {
          callApi();
          getTotalUnreadMessages();
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TitleAndButton(
                  title: AppLocalizations.of(context).translate('category'),
                  icon: true,
                  onPress: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (context) {
                        return const CategoriesMainScreen();
                      }),
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                  child: ListOfCategories(
                    categories: categories,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Stack(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: CarouselSlider(
                        carouselController: carouselController,
                        items: imgs.map((img) {
                          return Builder(builder: (BuildContext context) {
                            return Image.asset(
                              img["image"],
                              fit: BoxFit.fill,
                              width: double.infinity,
                            );
                          });
                        }).toList(),
                        options: CarouselOptions(
                          height: 160.h,
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          // aspectRatio: 3,
                          viewportFraction: 1,
                          // scrollDirection: Axis.horizontal,
                          // enableInfiniteScroll: true,
                          autoPlayCurve: Curves.easeInOut,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 300),
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imgs.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () =>
                                carouselController.animateToPage(entry.key),
                            child: Container(
                              width: currentIndex == entry.key ? 17 : 7,
                              height: 7.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: currentIndex == entry.key
                                    ? Colors.red
                                    : AppColor.backgroundColor,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),

                buildSection(
                  filter: 'الكترونيات',
                  title: 'elec',
                  bloc: elcDeviceBloc,
                  context: context,
                ),

                const SizedBox(
                  height: 10.0,
                ),

                buildSection(
                  filter: 'أجهزة المنزل والمكتب',
                  title: 'officeDevices',
                  bloc: deviceBloc,
                  context: context,
                ),
                const SizedBox(
                  height: 10.0,
                ),

                buildSection(
                  filter: 'موضة رجالية',
                  title: 'menFashion',
                  bloc: manFashionBloc,
                  context: context,
                ),
                const SizedBox(
                  height: 10.0,
                ),

                buildSection(
                  filter: 'موضة نسائية',
                  title: 'womanFashion',
                  bloc: womanFashionBloc,
                  context: context,
                ),
                const SizedBox(
                  height: 10.0,
                ),

                buildSection(
                  filter: 'منتجات غذائية',
                  title: 'foods',
                  bloc: foodsBloc,
                  context: context,
                ),
                const SizedBox(
                  height: 10.0,
                ),

                buildSection(
                  filter: 'عطور',
                  title: 'perfumes',
                  bloc: perfumesBloc,
                  context: context,
                ),
                const SizedBox(
                  height: 10.0,
                ),

                buildSection(
                  filter: 'ساعات',
                  title: 'watches',
                  bloc: watchesBloc,
                  context: context,
                ),
                const SizedBox(
                  height: 10.0,
                ),

                buildSection(
                  filter: 'حيوانات',
                  title: 'حيوانات',
                  bloc: animalBloc,
                  context: context,
                ),
                const SizedBox(
                  height: 10.0,
                ),

                buildSection(
                  filter: 'آلات موسيقية',
                  title: 'آلات موسيقية',
                  bloc: musicBloc,
                  context: context,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                buildSection(
                  filter: 'أجهزة رياضية',
                  title: 'أجهزة رياضية',
                  bloc: sportBloc,
                  context: context,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                buildSection(
                  filter: 'الزراعة',
                  title: 'الزراعة',
                  bloc: agricultureBloc,
                  context: context,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                buildSection(
                  filter: 'أخرى',
                  title: 'أخرى',
                  bloc: otherBloc,
                  context: context,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TitleAndButton(
                  title: AppLocalizations.of(context).translate('services'),
                  icon: true,
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const ServicesCategoriesScreen();
                        },
                      ),
                    );
                  },
                ),
                BlocBuilder<LocalCompanyBloc, LocalCompanyState>(
                  bloc: servicesBloc,
                  builder: (context, serviceState) {
                    if (serviceState is GetServicesCategoriesInProgress) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.backgroundColor,
                        ),
                      );
                    } else if (serviceState is GetServicesCategoriesFailure) {
                      final failure = serviceState.message;
                      return FailureWidget(
                        failure: failure,
                        onPressed: () {},
                      );
                    } else if (serviceState is GetServicesCategoriesSuccess) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 209, 219, 235)
                              .withOpacity(0.8),
                        ),
                        height: 300.r,
                        child: Center(
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.3.r,
                              crossAxisSpacing: 10.r,
                            ),
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ServicesByCategoryScreen(
                                          category: serviceState
                                              .servicesCategories[index].id,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  // padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor.white,
                                      border: Border.all(
                                        color: AppColor.backgroundColor,
                                      )),
                                  // child: ElevatedButton(
                                  //   onPressed: () {
                                  //     Navigator.of(context).push(
                                  //       MaterialPageRoute(
                                  //         builder: (context) {
                                  //           return ServicesByCategoryScreen(
                                  //             category: serviceState
                                  //                 .servicesCategories[index].id,
                                  //           );
                                  //         },
                                  //       ),
                                  //     );
                                  //   },
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: AppColor.white,
                                  //     // elevation: 3,

                                  //     shape: BeveledRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       side: const BorderSide(
                                  //           color: AppColor.backgroundColor,
                                  //           width: 0.6),
                                  //     ),
                                  //   ),
                                  //   child: Text(
                                  //     AppLocalizations.of(context).translate(
                                  //         serviceState
                                  //             .servicesCategories[index].title),
                                  //     textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //         color: AppColor.backgroundColor,
                                  //         fontSize: 11.sp,
                                  //         fontWeight: FontWeight.w700),
                                  //   ),
                                  // ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context).translate(
                                          serviceState
                                              .servicesCategories[index].title),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColor.backgroundColor,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                buildVehicleSection(
                    vehicleType: 'cars',
                    title: 'cars',
                    emptyText: 'there_is_no_cars_in_this_country',
                    bloc: carsBloc,
                    context: context,
                    onFailurePressed: () {
                      carsBloc.add(GetLatestCarByCreatorEvent());
                    }),
                const SizedBox(
                  height: 10.0,
                ),
                TitleAndButton(
                  title: AppLocalizations.of(context).translate('عقارات'),
                  icon: true,
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const RealEstateListScreen();
                      }),
                    );
                  },
                ),
                BlocBuilder<RealEstateBloc, RealEstateState>(
                  bloc: realEstateBloc,
                  builder: (context, state) {
                    if (state is GetRealEstateInProgress) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.backgroundColor,
                        ),
                      );
                    } else if (state is GetRealEstateFailure) {
                      final failure = state.message;
                      return FailureWidget(
                        failure: failure,
                        onPressed: () {
                          realEstateBloc.add(GetAllRealEstatesEvent());
                        },
                      );
                    } else if (state is GetAllRealEstatesSuccess) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        // decoration: BoxDecoration(
                        //   color: const Color.fromARGB(255, 209, 219, 235)
                        //       .withOpacity(0.8),
                        // ),
                        height: 130.h,
                        child: state.realEstates.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: state.realEstates.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return RealEstateDetailsScreen(
                                                realEstate:
                                                    state.realEstates[index]);
                                          },
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 10.0,
                                      shadowColor: AppColor.mainGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: SizedBox(
                                        height: 100.h,
                                        width: 180.w,
                                        child: Stack(
                                          // fit: StackFit.expand,
                                          alignment:
                                              AlignmentDirectional.bottomCenter,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              child: CachedNetworkImage(
                                                imageUrl: state
                                                    .realEstates[index]
                                                    .imageUrl,
                                                height: 200.h,
                                                width: double.maxFinite,
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 70.0,
                                                      vertical: 50),
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress,
                                                    color: AppColor
                                                        .backgroundColor,

                                                    // strokeWidth: 10,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    AppColor.backgroundColor
                                                        .withOpacity(0.6),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                state.realEstates[index].title,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  AppLocalizations.of(context).translate(
                                      'there is no realestates in this country'),
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                buildVehicleSection(
                    vehicleType: 'planes',
                    title: 'طائرات',
                    emptyText: 'there is no airplanes in this country',
                    bloc: planesBloc,
                    context: context,
                    onFailurePressed: () {
                      planesBloc.add(const GetAllPlanesEvent());
                    }),
                const SizedBox(
                  height: 10.0,
                ),
                TitleAndButton(
                  title: AppLocalizations.of(context).translate('deals'),
                  icon: true,
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const DealsCategoriesScreen(
                            title: 'فئات الصفقات',
                          );
                        },
                      ),
                    );
                  },
                ),
                BlocBuilder<DealsItemsBloc, DealsItemsState>(
                  bloc: dealsItemBloc,
                  builder: (context, state) {
                    if (state is DealsItemsInProgress) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.backgroundColor,
                        ),
                      );
                    } else if (state is DealsItemsFailure) {
                      final failure = state.message;
                      return FailureWidget(
                        failure: failure,
                        onPressed: () {
                          dealsItemBloc.add(GetDealsItemEvent());
                        },
                      );
                    } else if (state is DealsItemsSuccess) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 209, 219, 235)
                              .withOpacity(0.8),
                        ),
                        height: MediaQuery.of(context).size.height * 0.38,
                        child: state.dealsItems.isNotEmpty
                            ? DealsListWidget(
                                deals: state.dealsItems,
                                buttonText: AppLocalizations.of(context)
                                    .translate('buy_deal'),
                                subTitle: AppLocalizations.of(context)
                                    .translate('saller'),
                                desTitle1: AppLocalizations.of(context)
                                    .translate('prev_price'),
                                desTitle2: AppLocalizations.of(context)
                                    .translate('curr_price'),
                              )
                            : Center(
                                child: Text(
                                  AppLocalizations.of(context).translate(
                                      'there is no deals in this country'),
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                      );
                    }
                    return Container();
                  },
                ),

                const SizedBox(
                  height: 10.0,
                ),
                TitleAndButton(
                  title: AppLocalizations.of(context).translate('advertiments'),
                  icon: true,
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const AdvertisingScreen();
                        },
                      ),
                    );
                  },
                ),
                BlocBuilder<AdsBlocBloc, AdsBlocState>(
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
                      return FailureWidget(
                        failure: failure,
                        onPressed: () {
                          adsBloc.add(const GetAllAdsEvent());
                        },
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
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: SliderImages(advertisments: state.ads),
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                // TitleAndButton(
                //   title: AppLocalizations.of(context).translate('tenders'),
                //   icon: true,
                //   onPress: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) {
                //           return const TenderCategoriesScreen(
                //             title: 'فئات المناقصات',
                //           );
                //         },
                //       ),
                //     );
                //   },
                // ),
                // SizedBox(
                //     height: MediaQuery.of(context).size.height * 0.38,
                //     child: BlocBuilder<TendersItemBloc, TendersItemState>(
                //       bloc: tenderItemBloc,
                //       builder: (context, state) {
                //         if (state is TendersItemInProgress) {
                //           return const Center(
                //             child: CircularProgressIndicator(
                //               color: AppColor.backgroundColor,
                //             ),
                //           );
                //         } else if (state is TendersItemFailure) {
                //           final failure = state.message;
                //           return FailureWidget(
                //             failure: failure,
                //             onPressed: () {
                //               tenderItemBloc.add(const GetTendersItemEvent());
                //             },
                //           );
                //         } else if (state is TendersItemSuccess) {
                //           return TenderWidget(
                //             tenders: state.tenderItems,
                //             buttonText: AppLocalizations.of(context)
                //                 .translate('start_tender'),
                //             subTitle: AppLocalizations.of(context)
                //                 .translate('company_name'),
                //             desTitle1: AppLocalizations.of(context)
                //                 .translate('start_date'),
                //             desTitle2: AppLocalizations.of(context)
                //                 .translate('end_date'),
                //           );
                //         }
                //         return Container();
                //       },
                //     )),

                const SizedBox(
                  height: 10.0,
                ),
                TitleAndButton(
                  title: AppLocalizations.of(context).translate('news'),
                  icon: true,
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const NewsScreen();
                      }),
                    );
                  },
                ),
                const SizedBox(
                  height: 7.0,
                ),
                BlocBuilder<NewsBloc, NewsState>(
                  bloc: newsBloc,
                  builder: (context, state) {
                    if (state is NewsInProgress) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.backgroundColor,
                        ),
                      );
                    } else if (state is NewsFailure) {
                      final failure = state.message;
                      return FailureWidget(
                        failure: failure,
                        onPressed: () {
                          newsBloc.add(GetAllNewsEvent());
                        },
                      );
                    } else if (state is NewsSuccess) {
                      if (state.news.isEmpty) {
                        return NoDataWidget(
                          onPressed: () {
                            newsBloc.add(GetAllNewsEvent());
                          },
                        );
                      }
                      return SizedBox(
                        height: 330.r,
                        child: SliderNewsWidget(
                            controller: controller, news: state.news),
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(
                  height: 3.0,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  bloc: authBloc,
                  builder: (context, authState) {
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (authState is Authenticated) {
                              connectToSendbird(
                                  id: authState.user.userInfo.username ?? '');
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return const ChatHomeScreen();
                                }),
                              ).then((value) {
                                setState(() {
                                  totalUnreadMessageCount = 0;
                                });
                              });
                            } else {
                              authAlert(context);
                            }
                          },
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                transform: Matrix4.identity(),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColor.backgroundColor,
                                      width: 2,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    )),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate('chat_home'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColor.backgroundColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.12,
                                        width: 80.w,
                                        decoration: const BoxDecoration(
                                          color: AppColor.backgroundColor,
                                        ),
                                        child: Image.asset(
                                          'assets/images/vedio call2.png',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // child: SizedBox(
                          //   height: MediaQuery.of(context).size.height * 0.16,
                          //   width: double.infinity,
                          //   child: Image.asset(
                          //     'assets/images/chat.png',
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                        ),
                        Positioned(
                          top: -2,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            decoration: const BoxDecoration(
                              color: AppColor.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 30.0.w,
                              minHeight: 30.0.h,
                            ),
                            child: Text(
                              '$totalUnreadMessageCount',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 85.0.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
