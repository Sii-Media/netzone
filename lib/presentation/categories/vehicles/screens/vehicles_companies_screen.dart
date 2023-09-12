import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/vehicles/screens/vehicle_companies_profile_screen.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/no_data_widget.dart';

import '../../../../injection_container.dart';
import '../../../core/constant/colors.dart';
import '../../../utils/app_localizations.dart';
import '../blocs/bloc/vehicle_bloc.dart';

class VehiclesCompaniesScreen extends StatefulWidget {
  const VehiclesCompaniesScreen({super.key, required this.type});
  final String type;
  @override
  State<VehiclesCompaniesScreen> createState() =>
      _VehiclesCompaniesScreenState();
}

class _VehiclesCompaniesScreenState extends State<VehiclesCompaniesScreen> {
  final vehicleBloc = sl<VehicleBloc>();
  final controller = TextEditingController();

  @override
  void initState() {
    if (widget.type == 'cars') {
      vehicleBloc.add(GetCarsCompaniesEvent());
    } else if (widget.type == 'planes') {
      vehicleBloc.add(GetPlanesCompaniesEvent());
    } else if (widget.type == 'sea_companies') {
      vehicleBloc.add(GetSeaCompaniesEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: RefreshIndicator(
          onRefresh: () async {
            if (widget.type == 'cars') {
              vehicleBloc.add(GetCarsCompaniesEvent());
            } else if (widget.type == 'planes') {
              vehicleBloc.add(GetPlanesCompaniesEvent());
            } else if (widget.type == 'sea_companies') {
              vehicleBloc.add(GetSeaCompaniesEvent());
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<VehicleBloc, VehicleState>(
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
                  return Center(
                    child: Text(
                      failure,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else if (state is VehiclesCompaniesSuccess) {
                  final filteredUsers = state.vehiclesCompanies
                      .where((user) => user.username!
                          .toLowerCase()
                          .contains(controller.text.toLowerCase()))
                      .toList();
                  return Column(
                    children: [
                      TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                          ),
                          hintText:
                              AppLocalizations.of(context).translate('search'),
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
                      SizedBox(
                        height: 4.h,
                      ),
                      Expanded(
                        child: filteredUsers.isEmpty
                            ? NoDataWidget(onPressed: () {
                                if (widget.type == 'cars') {
                                  vehicleBloc.add(GetCarsCompaniesEvent());
                                } else if (widget.type == 'planes') {
                                  vehicleBloc.add(GetPlanesCompaniesEvent());
                                } else if (widget.type == 'sea_companies') {
                                  vehicleBloc.add(GetSeaCompaniesEvent());
                                }
                              })
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.85,
                                        crossAxisSpacing: 10.w,
                                        mainAxisSpacing: 10.h),
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: filteredUsers.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return VehicleCompaniesProfileScreen(
                                              vehiclesCompany:
                                                  filteredUsers[index],
                                            );
                                          }));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            child: SizedBox(
                                              height: 210.h,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    right: 0,
                                                    top: 0,
                                                    bottom: 0,
                                                    child: CachedNetworkImage(
                                                      imageUrl: state
                                                              .vehiclesCompanies[
                                                                  index]
                                                              .profilePhoto ??
                                                          '',
                                                      fit: BoxFit.fill,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    70.0,
                                                                vertical: 50),
                                                        child:
                                                            CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress,
                                                          color: AppColor
                                                              .backgroundColor,

                                                          // strokeWidth: 10,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 60.h,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      color: AppColor
                                                          .backgroundColor
                                                          .withOpacity(0.8),
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        state
                                                                .vehiclesCompanies[
                                                                    index]
                                                                .username ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.sp),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                      ),
                      const SizedBox(
                        height: 70,
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
    );
  }
}
