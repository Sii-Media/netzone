import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/companies_categories.dart';
import 'package:netzoon/presentation/categories/free_zoon/blocs/freezone_bloc/freezone_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class CategoriesFreeZone extends StatefulWidget {
  const CategoriesFreeZone({
    super.key,
  });

  @override
  State<CategoriesFreeZone> createState() => _CategoriesFreeZoneState();
}

class _CategoriesFreeZoneState extends State<CategoriesFreeZone> {
  final freezoneBloc = sl<FreezoneBloc>();

  @override
  void initState() {
    freezoneBloc.add(GetFreeZonePlacesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          freezoneBloc.add(GetFreeZonePlacesEvent());
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: BackgroundWidget(
          widget: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: BlocBuilder<FreezoneBloc, FreezoneState>(
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
                    } else if (state is FreezoneSuccess) {
                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.freezones.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.85,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemBuilder: (BuildContext context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      // if (widget.type == 'government') {
                                      //   return GovernmentInstitutionScreen(
                                      //     government: governmentList[index],
                                      //   );
                                      // }
                                      return CompaniesCategories(
                                        id: state.freezones[index].id,
                                      );
                                    }),
                                  );
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: Card(
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 0,
                                              bottom: 0,
                                              top: 0,
                                              right: 0,
                                              child: CachedNetworkImage(
                                                imageUrl: state
                                                    .freezones[index].imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  height: 50.h,
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  color:
                                                      AppColor.backgroundColor,
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(state
                                                            .freezones[index]
                                                            .name),
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors.white),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      )),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                )),
          ),
        ),
      ),
    );
  }
}
