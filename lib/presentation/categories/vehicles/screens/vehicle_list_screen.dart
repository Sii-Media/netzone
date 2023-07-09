import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';
import '../../../core/constant/colors.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../core/widgets/on_failure_widget.dart';
import '../../../core/widgets/vehicle_details.dart';
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

  @override
  void initState() {
    if (widget.vehicleType == 'planes') {
      vehicleBloc.add(GetAllPlanesEvent());
    } else {
      vehicleBloc.add(GetAllCarsEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
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
                  vehicleBloc.add(GetAllPlanesEvent());
                } else {
                  vehicleBloc.add(GetAllCarsEvent());
                }
              },
            );
          } else if (state is VehicleSuccess) {
            return Column(
              children: [
                GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.vehilces.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                vehicle: state.vehilces[index],
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
                                imageUrl: state.vehilces[index].imageUrl,
                                fit: BoxFit.cover,
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
                                    AppColor.backgroundColor.withOpacity(0.6),
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
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
    );
  }
}
