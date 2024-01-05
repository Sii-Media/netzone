import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/home/widgets/title_and_button.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import '../../categories/vehicles/screens/vehicle_list_screen.dart';
import '../../core/constant/colors.dart';
import '../../core/widgets/on_failure_widget.dart';
import '../../core/widgets/vehicle_details.dart';
import '../../ecommerce/screens/ecommerce.dart';
import '../blocs/elec_devices/elec_devices_bloc.dart';
import 'list_of_items.dart';

Widget buildSection({
  required String filter,
  required String title,
  required ElecDevicesBloc bloc,
  required BuildContext context,
}) {
  return Column(
    children: [
      TitleAndButton(
        title: AppLocalizations.of(context).translate(title),
        icon: true,
        onPress: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return CategoriesScreen(
                filter: filter,
              );
            }),
          );
        },
      ),
      BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is ElecDevicesInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (state is ElecDevicesFailure) {
            final failure = state.message;
            return FailureWidget(
              failure: failure,
              onPressed: () {
                bloc.add(GetElcDevicesEvent(department: filter));
              },
            );
          } else if (state is ElecDevicesSuccess) {
            return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 209, 219, 235).withOpacity(0.8),
              ),
              height: 123.h,
              child: ListofItems(
                filter: filter,
                elec: state.elecDevices,
              ),
            );
          }
          return Container();
        },
      ),
      const SizedBox(
        height: 10.0,
      ),
    ],
  );
}

Widget buildVehicleSection(
    {required String vehicleType,
    required String title,
    required String emptyText,
    required VehicleBloc bloc,
    required BuildContext context,
    required void Function()? onFailurePressed}) {
  return Column(
    children: [
      TitleAndButton(
        title: AppLocalizations.of(context).translate(title),
        icon: true,
        onPress: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return VehicleListScreen(
                vehicleType: vehicleType,
              );
            }),
          );
        },
      ),
      BlocBuilder<VehicleBloc, VehicleState>(
        bloc: bloc,
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
              onPressed: onFailurePressed,
            );
          } else if (state is VehicleSuccess) {
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
              child: state.vehilces.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.vehilces.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return VehicleDetailsScreen(
                                    vehicleId: state.vehilces[index].id ?? "",
                                  );
                                },
                              ),
                            );
                          },
                          child: Card(
                            elevation: 10.0,
                            shadowColor: AppColor.mainGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: SizedBox(
                              height: 100.h,
                              width: 180.w,
                              child: Stack(
                                // fit: StackFit.expand,
                                alignment: AlignmentDirectional.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: CachedNetworkImage(
                                      imageUrl: state.vehilces[index].imageUrl,
                                      height: 200.h,
                                      width: double.maxFinite,
                                      maxHeightDiskCache: 400,
                                      maxWidthDiskCache: 400,
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
                                      borderRadius: BorderRadius.circular(16.0),
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
                                      state.vehilces[index].name,
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
                        AppLocalizations.of(context).translate(emptyText),
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
    ],
  );
}
