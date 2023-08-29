import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:netzoon/presentation/ecommerce/widgets/listsubsectionswidget.dart';
import 'package:netzoon/presentation/home/blocs/elec_devices/elec_devices_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../core/screen/product_details_screen.dart';

class SubSectionsScreen extends StatefulWidget {
  const SubSectionsScreen({
    super.key,
    required this.filter,
    required this.category,
  });
  // final List<dynamic> list;
  final String filter;
  final String category;

  @override
  State<SubSectionsScreen> createState() => _SubSectionsScreenState();
}

class _SubSectionsScreenState extends State<SubSectionsScreen> {
  final elcDeviceBloc = sl<ElecDevicesBloc>();
  TextEditingController searchController = TextEditingController();
  String? ownerName;
  double priceMin = 0;
  double priceMax = 1000;
  String? condition;
  @override
  void initState() {
    elcDeviceBloc.add(GetElcCategoryProductsEvent(
        department: widget.filter, category: widget.category));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          widget: BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
        bloc: elcDeviceBloc,
        builder: (context, state) {
          if (state is ElecDevicesInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (state is ElecDevicesFailure) {
            final failure = state.message;
            return Center(
              child: Text(
                failure,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else if (state is ElecCategoryProductSuccess) {
            final filteredUsers = state.categoryProducts
                .where((prod) => prod.name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
                .toList();
            return state.categoryProducts.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context).translate('no_items'),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      elcDeviceBloc.add(GetElcCategoryProductsEvent(
                          department: widget.filter,
                          category: widget.category));
                    },
                    backgroundColor: AppColor.backgroundColor,
                    color: AppColor.white,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 70.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: searchController,
                                        onChanged: (value) {
                                          elcDeviceBloc.add(SearchProductsEvent(
                                              searchQuery: value));
                                          setState(() {});
                                        },
                                        style: const TextStyle(
                                            color: AppColor.black),
                                        decoration: InputDecoration(
                                          // filled: true,
                                          hintText: AppLocalizations.of(context)
                                              .translate('search'),
                                          hintStyle: const TextStyle(
                                              color: AppColor.secondGrey),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 30)
                                                  .flipped,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: AppColor
                                                    .backgroundColor), //<-- Set border color for focused state
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: AppColor
                                                    .backgroundColor), //<-- Set border color for enabled state
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: DynamicHeightGridView(
                                    itemCount: filteredUsers.length,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    builder: (ctx, index) {
                                      return ListSubSectionsWidget(
                                        deviceList: filteredUsers[index],
                                        department: state.department,
                                        category: state.category,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ProductDetailScreen(
                                                  item: filteredUsers[index].id,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );

                                      /// return your widget here.
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          }
          return Container();
        },
      )),
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
                      max: 1000,
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
                    const SizedBox(height: 16),
                    // Radio buttons for condition
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context).translate('condition')} :',
                          style: const TextStyle(
                            color: AppColor.white,
                          ),
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'new',
                              groupValue: condition,
                              onChanged: (value) {
                                setState(() {
                                  condition = value;
                                });
                              },
                              activeColor: AppColor.white,
                            ),
                            Text(
                              AppLocalizations.of(context).translate('new'),
                              style: const TextStyle(
                                color: AppColor.white,
                              ),
                            ),
                            Radio<String>(
                              value: 'used',
                              groupValue: condition,
                              focusColor: AppColor.white,
                              onChanged: (value) {
                                setState(() {
                                  condition = value;
                                });
                              },
                              activeColor: AppColor.white,
                            ),
                            Text(
                              AppLocalizations.of(context).translate('used'),
                              style: const TextStyle(
                                color: AppColor.white,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                        elcDeviceBloc.add(GetElcCategoryProductsEvent(
                          department: widget.filter,
                          category: widget.category,
                          owner: ownerName,
                          priceMin: priceMin.toInt(),
                          priceMax: priceMax.toInt(),
                          condition: condition,
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
