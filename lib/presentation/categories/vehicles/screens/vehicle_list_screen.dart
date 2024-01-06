import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';
import '../../../core/constant/colors.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../core/widgets/on_failure_widget.dart';
import '../../../core/widgets/vehicle_details.dart';
import '../../../utils/app_localizations.dart';
import '../blocs/bloc/vehicle_bloc.dart';

class VehicleListScreen extends StatefulWidget {
  final String vehicleType;
  const VehicleListScreen({
    super.key,
    required this.vehicleType,
  });

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final vehicleBloc = sl<VehicleBloc>();
  final controller = TextEditingController();
  String? ownerName;
  double priceMin = 0;
  double priceMax = 1000000;

  String? type;
  @override
  void initState() {
    if (widget.vehicleType == 'planes') {
      vehicleBloc.add(const GetAllPlanesEvent());
    } else {
      vehicleBloc.add(const GetAllCarsEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (widget.vehicleType == 'planes') {
            vehicleBloc.add(const GetAllPlanesEvent());
          } else {
            vehicleBloc.add(const GetAllCarsEvent());
          }
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: BackgroundWidget(
            isHome: false,
            widget: BlocBuilder<VehicleBloc, VehicleState>(
              bloc: vehicleBloc,
              builder: (context, state) {
                if (state is VehicleInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  );
                } else if (state is VehicleFailure) {
                  final failure = state.message;
                  return FailureWidget(
                    failure: failure,
                    onPressed: () {
                      if (widget.vehicleType == 'planes') {
                        vehicleBloc.add(const GetAllPlanesEvent());
                      } else {
                        vehicleBloc.add(const GetAllCarsEvent());
                      }
                    },
                  );
                } else if (state is VehicleSuccess) {
                  final filteredCars = state.vehilces
                      .where((vehicle) => vehicle.name
                          .toLowerCase()
                          .contains(controller.text.toLowerCase()))
                      .toList();
                  return Column(
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 15.sp,
                                  ),
                                  hintText: AppLocalizations.of(context)
                                      .translate('search'),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                    borderSide: const BorderSide(
                                      color: AppColor.backgroundColor,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     _showFilterBottomSheet(context);
                            //   },
                            //   icon: Icon(
                            //     Icons.filter_alt,
                            //     color: AppColor.backgroundColor,
                            //     size: 30.sp,
                            //   ),
                            // ),
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
                      const SizedBox(
                        height: 2,
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredCars.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return VehicleDetailsScreen(
                                        vehicleId: filteredCars[index].id ?? '',
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: CachedNetworkImage(
                                        imageUrl: filteredCars[index].imageUrl,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Padding(
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
                                        filteredCars[index].name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
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
            )),
      ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${AppLocalizations.of(context).translate('from')}:   $priceMin',
                          style: const TextStyle(
                            color: AppColor.white,
                          ),
                        ),
                        Text(
                          '${AppLocalizations.of(context).translate('to')}:  $priceMax',
                          style: const TextStyle(
                            color: AppColor.white,
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
                        });
                      },
                      activeColor: AppColor.white,
                      divisions: 100000,
                      labels: RangeLabels(priceMin.toInt().toString(),
                          priceMax.toInt().toString()),
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
                              groupValue: type,
                              onChanged: (value) {
                                setState(() {
                                  type = value;
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
                              groupValue: type,
                              focusColor: AppColor.white,
                              onChanged: (value) {
                                setState(() {
                                  type = value;
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
                        if (widget.vehicleType == 'planes') {
                          vehicleBloc.add(GetAllPlanesEvent(
                            creator: ownerName,
                            priceMin: priceMin.toInt(),
                            priceMax: priceMax.toInt(),
                            type: type,
                          ));
                        } else {
                          vehicleBloc.add(GetAllCarsEvent(
                            creator: ownerName,
                            priceMin: priceMin.toInt(),
                            priceMax: priceMax.toInt(),
                            type: type,
                          ));
                        }
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
