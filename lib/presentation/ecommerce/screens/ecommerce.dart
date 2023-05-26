import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/ecommerce/widgets/list_categories.dart';
import 'package:netzoon/presentation/home/blocs/elec_devices/elec_devices_bloc.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen(
      {super.key, required this.items, required this.filter});

  final List<dynamic> items;
  final String filter;
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final elcDeviceBloc = sl<ElecDevicesBloc>();

  @override
  void initState() {
    elcDeviceBloc.add(GetElcDevicesEvent(department: widget.filter));

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
            } else if (state is ElecDevicesSuccess) {
              return ListCategoriesEcommerce(
                items: state.elecDevices,
                filter: widget.filter,
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
