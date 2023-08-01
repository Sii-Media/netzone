import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/customs_screen/customs_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../../injection_container.dart';
import '../../core/widgets/background_widget.dart';
import 'customs_bloc/customs_bloc.dart';

class CustomsCompaniesScreen extends StatefulWidget {
  const CustomsCompaniesScreen({super.key, required this.id});
  final String id;
  @override
  State<CustomsCompaniesScreen> createState() => _CustomsCompaniesScreenState();
}

class _CustomsCompaniesScreenState extends State<CustomsCompaniesScreen> {
  final customsBloc = sl<CustomsBloc>();

  @override
  void initState() {
    customsBloc.add(GetCustomsCompaniesEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: RefreshIndicator(
        onRefresh: () async {
          customsBloc.add(GetCustomsCompaniesEvent(id: widget.id));
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BackgroundWidget(
            isHome: false,
            widget: BlocBuilder<CustomsBloc, CustomsState>(
              bloc: customsBloc,
              builder: (context, state) {
                if (state is CustomsInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  );
                } else if (state is CustomsFailure) {
                  final failure = state.message;
                  return Center(
                    child: Text(
                      failure,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else if (state is CustomsCompaniesSuccess) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.companies.customsplaces.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return CustomsScreen(
                                      customsCategory:
                                          state.companies.customsplaces[index],
                                    );
                                  }));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      right: 5.0, top: 10.0),
                                  width: MediaQuery.of(context).size.width,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: AppColor.backgroundColor
                                        .withOpacity(0.1),
                                    border: const Border(
                                      bottom: BorderSide(
                                        color: AppColor.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context).translate(state
                                        .companies.customsplaces[index].name),
                                    style: TextStyle(
                                        color: AppColor.black,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    ));
  }
}
