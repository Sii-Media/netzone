import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/tenders/blocs/tendersItem/tenders_item_bloc.dart';
import 'package:netzoon/presentation/tenders/tender_info_screen.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class ViewAllTendersScreen extends StatefulWidget {
  const ViewAllTendersScreen({
    super.key,
    required this.sort,
    required this.category,
    // required this.tenders,
  });
  // final List<Tender> tenders;
  final String sort;
  final String category;

  @override
  State<ViewAllTendersScreen> createState() => _ViewAllTendersScreenState();
}

class _ViewAllTendersScreenState extends State<ViewAllTendersScreen> {
  final tenderItemBloc = sl<TendersItemBloc>();

  @override
  void initState() {
    if (widget.sort == 'min') {
      tenderItemBloc.add(GetTendersItemByMinEvent(category: widget.category));
    } else {
      tenderItemBloc.add(GetTendersItemByMaxEvent(category: widget.category));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final tendersList = tendersCategrories;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: RefreshIndicator(
            onRefresh: () async {
              if (widget.sort == 'min') {
                tenderItemBloc
                    .add(GetTendersItemByMinEvent(category: widget.category));
              } else {
                tenderItemBloc
                    .add(GetTendersItemByMaxEvent(category: widget.category));
              }
            },
            color: AppColor.white,
            backgroundColor: AppColor.backgroundColor,
            child: BlocBuilder<TendersItemBloc, TendersItemState>(
              bloc: tenderItemBloc,
              builder: (context, state) {
                if (state is TendersItemInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  );
                } else if (state is TendersItemFailure) {
                  final failure = state.message;
                  return Center(
                    child: Text(
                      failure,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else if (state is TendersItemSuccess) {
                  return state.tenderItems.isNotEmpty
                      ? SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.tenderItems.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return TenderInfoScreen(
                                          tender: state.tenderItems[index],
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5),
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      blurRadius: 1,
                                                    )
                                                  ]),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.0.w),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  state
                                                                      .tenderItems[
                                                                          index]
                                                                      .nameAr,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16.sp),
                                                                ),
                                                                SizedBox(
                                                                  height: 8.0.h,
                                                                ),
                                                                Text(
                                                                  '${AppLocalizations.of(context).translate('company_name')} : ${state.tenderItems[index].companyName}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 4.0.h,
                                                                ),
                                                                Text(
                                                                  '${AppLocalizations.of(context).translate('start_price')}: ${state.tenderItems[index].price}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppColor
                                                                        .backgroundColor,
                                                                    fontSize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8.0.h,
                                                                ),
                                                                Text(
                                                                  '${AppLocalizations.of(context).translate('start_date')}: ${convertDateToString(state.tenderItems[index].startDate)}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .orange,
                                                                      fontSize:
                                                                          12.sp),
                                                                ),
                                                                SizedBox(
                                                                  height: 4.h,
                                                                ),
                                                                Text(
                                                                  '${AppLocalizations.of(context).translate('end_date')}: ${convertDateToString(state.tenderItems[index].endDate)}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .orange,
                                                                      fontSize:
                                                                          12.sp),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0),
                                                            // child: Image.network(
                                                            //   tenders[index].imgUrl,
                                                            //   fit: BoxFit.fitHeight,
                                                            //   width: 170.w,
                                                            //   height: 150.h,
                                                            // ),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: state
                                                                  .tenderItems[
                                                                      index]
                                                                  .type,
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              width: 170.w,
                                                              height: 150.h,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 4.h),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0xFF5776a5),
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          20),
                                                                  //shadowColor: Colors.black,
                                                                  //  elevation: 5
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  textStyle:
                                                                      const TextStyle(
                                                                          fontSize:
                                                                              15)),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(
                                                                    'start_tender'),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            AppLocalizations.of(context).translate('no_items'),
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 25.sp,
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
    );
  }
}
