import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/real_estate/blocs/real_estate/real_estate_bloc.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_details_screen.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

import '../../../../injection_container.dart';
import '../../../core/constant/colors.dart';
import '../../../core/widgets/on_failure_widget.dart';
import '../../../utils/app_localizations.dart';

class RealEstateListScreen extends StatefulWidget {
  const RealEstateListScreen({super.key});

  @override
  State<RealEstateListScreen> createState() => _RealEstateListScreenState();
}

class _RealEstateListScreenState extends State<RealEstateListScreen> {
  final realEstateBloc = sl<RealEstateBloc>();
  final controller = TextEditingController();
  @override
  void initState() {
    realEstateBloc.add(GetAllRealEstatesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          realEstateBloc.add(GetAllRealEstatesEvent());
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: BackgroundWidget(
          widget: BlocBuilder<RealEstateBloc, RealEstateState>(
            bloc: realEstateBloc,
            builder: (context, state) {
              if (state is GetRealEstateInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                );
              } else if (state is GetRealEstateFailure) {
                final failure = state.message;
                return FailureWidget(
                  failure: failure,
                  onPressed: () {
                    realEstateBloc.add(GetAllRealEstatesEvent());
                  },
                );
              } else if (state is GetAllRealEstatesSuccess) {
                final filteredRealEstate = state.realEstates
                    .where((realEstate) => realEstate.title
                        .toLowerCase()
                        .contains(controller.text.toLowerCase()))
                    .toList();
                return Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
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
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredRealEstate.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    return RealEstateDetailsScreen(
                                        realEstate: filteredRealEstate[index]);
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
                                      imageUrl:
                                          filteredRealEstate[index].imageUrl,
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
                                      filteredRealEstate[index].title,
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
                    ),
                    SizedBox(
                      height: 80.h,
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
