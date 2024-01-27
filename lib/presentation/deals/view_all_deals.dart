import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/deals/blocs/dealsItems/deals_items_bloc.dart';
import 'package:netzoon/presentation/deals/deals_details.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';

import '../utils/remaining_date.dart';

class ViewAllDealsScreen extends StatefulWidget {
  const ViewAllDealsScreen({
    super.key,
    // required this.dealsInfoList,
    required this.category,
  });

  // final List<DealsInfo> dealsInfoList;
  final String category;

  @override
  State<ViewAllDealsScreen> createState() => _ViewAllDealsScreenState();
}

class _ViewAllDealsScreenState extends State<ViewAllDealsScreen> {
  final dealsItemBloc = sl<DealsItemsBloc>();
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  String? companyName;

  @override
  void initState() {
    minPriceController.text = priceMin.toString();
    maxPriceController.text = priceMax.toString();
    dealsItemBloc.add(DealsItemsByCatEvent(category: widget.category));
    super.initState();
  }

  double priceMin = 0;
  double priceMax = 1000000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
      isHome: false,
      // title: "المناقصات",
      widget: BlocBuilder<DealsItemsBloc, DealsItemsState>(
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
            return Center(
              child: Text(
                failure,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25.sp,
                ),
              ),
            );
          } else if (state is DealsItemsSuccess) {
            final filteredUsers = state.dealsItems
                .where((prod) => prod.name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
                .toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: TextFormField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            style: const TextStyle(color: AppColor.black),
                            decoration: InputDecoration(
                              // filled: true,
                              hintText: AppLocalizations.of(context)
                                  .translate('search'),
                              hintStyle:
                                  const TextStyle(color: AppColor.secondGrey),
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
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     _showFilterBottomSheet(context);
                      //   },
                      //   icon: const Icon(
                      //     Icons.filter_alt,
                      //     color: AppColor.backgroundColor,
                      //     size: 30,
                      //   ),
                      // )
                      InkWell(
                        onTap: () {
                          _showFilterBottomSheet(context);
                        },
                        child: Icon(
                          Icons.filter_alt,
                          color: AppColor.backgroundColor,
                          size: 30.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredUsers.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Deals(
                          dealsInfo: filteredUsers[index],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 80.h,
                ),
              ],
            );
          }
          return Container();
        },
      ),
    ));
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
                          companyName = value;
                        });
                      },
                      style: const TextStyle(color: AppColor.white),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: AppLocalizations.of(context)
                            .translate('search_by_company_name'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: TextFormField(
                            controller: minPriceController,
                            onChanged: (value) {
                              // setState(() {
                              //   priceMin = double.tryParse(value) ?? 1000000.0;
                              // });
                              setState(() {
                                if (double.tryParse(value)! > 0 &&
                                    double.tryParse(value)! < priceMax) {
                                  priceMin = double.tryParse(value) ?? 0.0;
                                }
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)
                                    .translate('required');
                              }
                              if (double.tryParse(value)! > priceMax) {
                                return 'should be less than $priceMax';
                              }
                              return null;
                            },
                            style: const TextStyle(color: AppColor.white),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: AppLocalizations.of(context)
                                  .translate('from'),
                              labelText: AppLocalizations.of(context)
                                  .translate('from'),
                              labelStyle:
                                  const TextStyle(color: AppColor.white),
                              hintStyle: const TextStyle(color: AppColor.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5)
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
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        // Text(
                        //   '${AppLocalizations.of(context).translate('from')}:   $priceMin',
                        //   style: const TextStyle(
                        //     color: AppColor.white,
                        //   ),
                        // ),
                        // Text(
                        //   '${AppLocalizations.of(context).translate('to')}:  $priceMax',
                        //   style: const TextStyle(
                        //     color: AppColor.white,
                        //   ),
                        // ),
                        SizedBox(
                          width: 100.w,
                          child: TextFormField(
                            controller: maxPriceController,
                            onChanged: (value) {
                              setState(() {
                                if (double.tryParse(value)! > priceMin &&
                                    double.tryParse(value)! < 1000000) {
                                  priceMax =
                                      double.tryParse(value) ?? 1000000.0;
                                }
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)
                                    .translate('required');
                              }
                              if (double.tryParse(value)! < priceMin) {
                                return 'should be greater than $priceMin';
                              }
                              return null;
                            },
                            style: const TextStyle(color: AppColor.white),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              hintText:
                                  AppLocalizations.of(context).translate('to'),
                              labelText:
                                  AppLocalizations.of(context).translate('to'),
                              labelStyle:
                                  const TextStyle(color: AppColor.white),
                              hintStyle: const TextStyle(color: AppColor.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5)
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
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: RangeValues(priceMin, priceMax),
                      min: 0,
                      max: 1000000,
                      onChanged: (RangeValues values) {
                        setState(() {
                          priceMin = values.start;
                          priceMax = values.end;
                          minPriceController.text = priceMin.toString();
                          maxPriceController.text = priceMax.toString();
                        });
                      },
                      activeColor: AppColor.white,
                      divisions: 1000,
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
                        dealsItemBloc.add(DealsItemsByCatEvent(
                          category: widget.category,
                          companyName: companyName,
                          minPrice: priceMin.toInt(),
                          maxPrice: priceMax.toInt(),
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

class Deals extends StatelessWidget {
  const Deals({super.key, required this.dealsInfo});

  final DealsItems dealsInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return DealDetails(
                dealsInfoId: dealsInfo.id ?? '',
              );
            }),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1,
              )
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 180.w,
                          child: Text(
                            dealsInfo.name,
                            style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 20.sp),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: CachedNetworkImage(
                            imageUrl: dealsInfo.imgUrl,
                            fit: BoxFit.fill,
                            width: 160.w,
                            height: 150.h,
                            maxHeightDiskCache: 400,
                            maxWidthDiskCache: 400,
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
                          // child: Image.network(
                          //   dealsInfo.imgUrl,
                          //   fit: BoxFit.fill,
                          //   width: 160.w,
                          //   height: 150.h,
                          // ),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context).translate('اسم البائع')}: ${dealsInfo.companyName}",
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 15.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context).translate('السعر قبل')} : ",
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                Text(
                                  dealsInfo.prevPrice.toString(),
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context).translate('السعر بعد')} : ",
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                Text(
                                  dealsInfo.currentPrice.toString(),
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${AppLocalizations.of(context).translate('الصفقة صالحة لغاية')} ${convertDateToString(dealsInfo.endDate)}',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 13.sp),
                              textAlign: TextAlign.start,
                            ),
                            // Text(
                            //   '${AppLocalizations.of(context).translate('remaining')} : ${calculateRemainingDays(dealsInfo.endDate) >= 0 ? calculateRemainingDays(dealsInfo.endDate).toString() : 'finished'}',
                            //   style: TextStyle(
                            //       color: AppColor.backgroundColor,
                            //       fontSize: 13.sp,
                            //       fontWeight: FontWeight.bold),
                            //   textAlign: TextAlign.center,
                            // ),
                            RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColor.backgroundColor),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          '${AppLocalizations.of(context).translate('remaining')} :',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: calculateRemainingDays(
                                                  dealsInfo.endDate) >=
                                              0
                                          ? calculateRemainingDays(
                                                  dealsInfo.endDate)
                                              .toString()
                                          : 'finished',
                                      style: const TextStyle(
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 4.h),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return DealDetails(
                              dealsInfoId: dealsInfo.id ?? '',
                            );
                          }),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.backgroundColor,
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          //shadowColor: Colors.black,
                          //  elevation: 5
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          textStyle: TextStyle(fontSize: 15.sp)),
                      child: Text(
                          AppLocalizations.of(context).translate("buy_deal"))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
