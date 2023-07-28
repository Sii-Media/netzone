import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/vehicles/screens/vehicle_companies_profile_screen.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

import '../../../../injection_container.dart';
import '../../../core/constant/colors.dart';
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

  @override
  void initState() {
    if (widget.type == 'cars') {
      vehicleBloc.add(GetCarsCompaniesEvent());
    } else if (widget.type == 'planes') {
      vehicleBloc.add(GetPlanesCompaniesEvent());
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
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.vehiclesCompanies.length,
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
                                          MaterialPageRoute(builder: (context) {
                                        return VehicleCompaniesProfileScreen(
                                          vehiclesCompany:
                                              state.vehiclesCompanies[index],
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
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 60.h,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  color: AppColor
                                                      .backgroundColor
                                                      .withOpacity(0.8),
                                                  child: Text(
                                                    state
                                                            .vehiclesCompanies[
                                                                index]
                                                            .username ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20.sp),
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
