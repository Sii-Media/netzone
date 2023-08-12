import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/map_to_date.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/vehicle_details.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../helpers/share_image_function.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key, required this.category, this.type});

  final String category;
  final String? type;

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final vehilceBloc = sl<VehicleBloc>();

  @override
  void initState() {
    if (widget.category == 'cars') {
      vehilceBloc.add(const GetAllCarsEvent());
    } else if (widget.category == 'plans' && widget.type == 'new') {
      vehilceBloc.add(GetAllNewPlanesEvent());
    } else if (widget.category == 'plans' && widget.type == 'used') {
      vehilceBloc.add(GetAllUsedPlanesEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.only(
            top: 2.0,
            bottom: 25,
            left: 3.0,
            right: 3.0,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              if (widget.category == 'cars') {
                vehilceBloc.add(const GetAllCarsEvent());
              } else if (widget.category == 'plans' && widget.type == 'new') {
                vehilceBloc.add(GetAllNewPlanesEvent());
              } else if (widget.category == 'plans' && widget.type == 'used') {
                vehilceBloc.add(GetAllUsedPlanesEvent());
              }
            },
            color: AppColor.white,
            backgroundColor: AppColor.backgroundColor,
            child: BlocBuilder<VehicleBloc, VehicleState>(
              bloc: vehilceBloc,
              builder: (context, state) {
                if (state is VehicleInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  );
                } else if (state is VehicleFailure) {
                  final failure = state.message;
                  return Center(
                    child: Text(
                      failure,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                if (state is VehicleSuccess) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: ListView.builder(
                      // itemCount: widget.type == 'plans'
                      //     ? planslist.length
                      //     : carList.length,
                      itemCount: state.vehilces.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return VehicleWidget(
                          plan: state.vehilces[index],
                          // plan: widget.type == 'plans'
                          //     ? planslist[index]
                          //     : carList[index],
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
      ),
    );
  }
}

class VehicleWidget extends StatelessWidget {
  const VehicleWidget({
    super.key,
    required this.plan,
  });

  final Vehicle plan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return VehicleDetailsScreen(
                  vehicle: plan,
                );
              },
            ),
          );
        },
        child: Card(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: plan.imageUrl,
                    width: 700.w,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan.price.toString(),
                      style: TextStyle(
                          color: AppColor.colorOne,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const Icon(
                        //   Icons.favorite_border,
                        //   color: AppColor.backgroundColor,
                        // ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await shareImageWithDescription(
                                imageUrl: plan.imageUrl,
                                description: plan.description);
                          },
                          child: const Icon(
                            Icons.share,
                            color: AppColor.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  plan.name,
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  plan.description,
                  style: TextStyle(
                    color: AppColor.secondGrey,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          '${AppLocalizations.of(context).translate('kilometers')} :',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          plan.kilometers.toString(),
                          style: TextStyle(
                            color: AppColor.secondGrey,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Row(
                      children: [
                        Text(
                          '${AppLocalizations.of(context).translate('year')} :',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          formatDate(plan.year),
                          style: TextStyle(
                            color: AppColor.secondGrey,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColor.secondGrey,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      plan.location,
                      style: TextStyle(
                        color: AppColor.secondGrey,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
