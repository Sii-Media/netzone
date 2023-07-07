import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/governmental/govermental_bloc/govermental_bloc.dart';
import 'package:netzoon/presentation/categories/governmental/govermental_details.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/custom_appbar.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class GovernmentInstitutionScreen extends StatefulWidget {
  const GovernmentInstitutionScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<GovernmentInstitutionScreen> createState() =>
      _GovernmentInstitutionScreenState();
}

class _GovernmentInstitutionScreenState
    extends State<GovernmentInstitutionScreen> {
  final goverBloc = sl<GovermentalBloc>();

  @override
  void initState() {
    goverBloc.add(GetGovermentalCompaniesEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController search = TextEditingController();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<GovermentalBloc, GovermentalState>(
        bloc: goverBloc,
        builder: (context, state) {
          if (state is GovermentalInProgress) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColor.backgroundColor,
                ),
              ),
            );
          } else if (state is GovermentalFailure) {
            final failure = state.message;
            return Center(
              child: Text(
                failure,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else if (state is GovermentalCompaniesSuccess) {
            return SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: AppColor.mainGrey.withOpacity(0.1)),
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(0, 3)),
                        ],
                      ),
                    ),
                  ),
                  customAppBar(context),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 150.h,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).translate(
                            state.companies.govermentalCompanies[0].govname),
                        style: TextStyle(
                            fontSize: 22.sp, color: AppColor.backgroundColor),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 202.h,
                    right: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 1, bottom: 14, left: 20, right: 20),
                      height: MediaQuery.of(context).size.height - 191.h,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.95,
                                    crossAxisSpacing: 10.w,
                                    mainAxisSpacing: 10.h),
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                state.companies.govermentalCompanies.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return GovermentalDetailsScreen(
                                        govermentalDetails: state.companies
                                            .govermentalCompanies[index],
                                      );
                                    }));
                                  },
                                  child: Card(
                                    shadowColor: Colors.grey,
                                    child: CachedNetworkImage(
                                      imageUrl: state.companies
                                          .govermentalCompanies[index].imgurl,
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
