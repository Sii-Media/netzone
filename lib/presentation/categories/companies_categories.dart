import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/company_profile.dart';
import 'package:netzoon/presentation/categories/free_zoon/blocs/freezone_bloc/freezone_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class CompaniesCategories extends StatefulWidget {
  const CompaniesCategories({super.key, required this.id});

  final String id;

  @override
  State<CompaniesCategories> createState() => _CompaniesCategoriesState();
}

class _CompaniesCategoriesState extends State<CompaniesCategories> {
  final freezoneBloc = sl<FreezoneBloc>();

  @override
  void initState() {
    freezoneBloc.add(GetFreeZonePlacesByIdEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: BackgroundWidget(
          widget: BlocBuilder<FreezoneBloc, FreezoneState>(
            bloc: freezoneBloc,
            builder: (context, state) {
              if (state is FreezoneInProgress) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  ),
                );
              } else if (state is FreezoneFailure) {
                final failure = state.message;
                return Center(
                  child: Text(
                    failure,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              } else if (state is FreezoneByIdSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            state.freezonescompanies.freezoonplaces.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return CompanyProfile(
                                      companyCategory: state.freezonescompanies
                                          .freezoonplaces[index],
                                    );
                                    // : CustomsScreen(
                                    //     customsCategory:
                                    //         widget.companiesList[index],
                                    //   );
                                  }),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    right: 5.0, top: 10.0),
                                width: MediaQuery.of(context).size.width,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color:
                                      AppColor.backgroundColor.withOpacity(0.1),
                                  border: const Border(
                                    bottom: BorderSide(
                                      color: AppColor.black,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context).translate(state
                                      .freezonescompanies
                                      .freezoonplaces[index]
                                      .name),
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
    ));
  }
}
