import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/real_estate/real_estate.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

import '../../../core/blocs/country_bloc/country_bloc.dart';
import '../../../core/constant/colors.dart';
import '../../../core/helpers/get_currency_of_country.dart';
import '../../../core/helpers/share_image_function.dart';
import '../../../core/widgets/price_suggestion_button.dart';
import '../../../utils/app_localizations.dart';
import '../../widgets/image_free_zone_widget.dart';

class RealEstateDetailsScreen extends StatefulWidget {
  final RealEstate realEstate;
  const RealEstateDetailsScreen({super.key, required this.realEstate});

  @override
  State<RealEstateDetailsScreen> createState() =>
      _RealEstateDetailsScreenState();
}

class _RealEstateDetailsScreenState extends State<RealEstateDetailsScreen> {
  final TextEditingController input = TextEditingController();
  late final CountryBloc countryBloc;

  @override
  void initState() {
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<CountryBloc, CountryState>(
              bloc: countryBloc,
              builder: (context, state) {
                if (state is CountryInitial) {
                  return Column(
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
                              imageUrl: widget.realEstate.imageUrl,
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
                                      // Text(
                                      //   '${widget.realEstate.price.toString()} \$',
                                      //   style: TextStyle(
                                      //       color: AppColor.colorOne,
                                      //       fontSize: 17.sp,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                      RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color:
                                                    AppColor.backgroundColor),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${widget.realEstate.price}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text: getCurrencyFromCountry(
                                                  state.selectedCountry,
                                                  context,
                                                ),
                                                style: TextStyle(
                                                    color: AppColor
                                                        .backgroundColor,
                                                    fontSize: 14.sp),
                                              )
                                            ]),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              await shareImageWithDescription(
                                                  imageUrl: widget
                                                      .realEstate.imageUrl,
                                                  description: widget
                                                      .realEstate.description);
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
                                    widget.realEstate.title,
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
                                title: AppLocalizations.of(context)
                                    .translate('owner'),
                                input:
                                    widget.realEstate.createdBy.username ?? '',
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('area'),
                                input: widget.realEstate.area.toString(),
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('Bathrooms'),
                                input: widget.realEstate.bathrooms.toString(),
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('Bedrooms'),
                                input: widget.realEstate.bedrooms.toString(),
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('address'),
                                input: widget.realEstate.location,
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
                              widget.realEstate.description,
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
                            widget.realEstate.images?.isNotEmpty == true
                                ? SizedBox(
                                    height: 200.h,
                                    // width: 120,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            widget.realEstate.images!.length,
                                        // gridDelegate:
                                        //     const SliverGridDelegateWithFixedCrossAxisCount(
                                        //         crossAxisCount: 2,
                                        //         childAspectRatio: 0.94),
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            child: ListOfPictures(
                                              img: widget
                                                  .realEstate.images![index],
                                            ),
                                          );
                                        }),
                                  )
                                : Text(
                                    AppLocalizations.of(context)
                                        .translate('no_images'),
                                    style: TextStyle(
                                      color: AppColor.mainGrey,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 140.h,
                      ),
                    ],
                  );
                }
                return Container();
              },
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
            // ElevatedButton(
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all(
            //       AppColor.backgroundColor,
            //     ),
            //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(18.0),
            //     )),
            //     fixedSize: const MaterialStatePropertyAll(
            //       Size.fromWidth(200),
            //     ),
            //   ),
            //   child: Text(AppLocalizations.of(context).translate('buy')),
            //   onPressed: () {},
            // ),
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
