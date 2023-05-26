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
                : Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: DynamicHeightGridView(
                          itemCount: state.categoryProducts.length,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          builder: (ctx, index) {
                            return ListSubSectionsWidget(
                              deviceList: state.categoryProducts[index],
                            );

                            /// return your widget here.
                          }),
                    ),
                  );
          }
          return Container();
        },
      )),
    );
  }
}
