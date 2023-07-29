import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';

import '../../injection_container.dart';
import 'blocs/dealsItems/deals_items_bloc.dart';
import 'edit_deal_screen.dart';

class DealDetails extends StatefulWidget {
  const DealDetails({super.key, required this.dealsInfoId});

  final String dealsInfoId;

  @override
  State<DealDetails> createState() => _DealDetailsState();
}

class _DealDetailsState extends State<DealDetails> {
  final dealBloc = sl<DealsItemsBloc>();
  @override
  void initState() {
    dealBloc.add(GetDealByIdEvent(id: widget.dealsInfoId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          dealBloc.add(GetDealByIdEvent(id: widget.dealsInfoId));
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: BackgroundWidget(
              widget: BlocBuilder<DealsItemsBloc, DealsItemsState>(
                bloc: dealBloc,
                builder: (context, state) {
                  if (state is DealsItemsInProgress) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.backgroundColor,
                        ),
                      ),
                    );
                  } else if (state is DealsItemsFailure) {
                    final failure = state.message;
                    return FailureWidget(
                      failure: failure,
                      onPressed: () {
                        dealBloc.add(GetDealByIdEvent(id: widget.dealsInfoId));
                      },
                    );
                  } else if (state is GetDealByIdSuccess) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        dealBloc.add(GetDealByIdEvent(id: widget.dealsInfoId));
                      },
                      color: AppColor.white,
                      backgroundColor: AppColor.backgroundColor,
                      child: ListView(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            height: size.height * 0.30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: CachedNetworkImage(
                                imageUrl: state.deal.imgUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return EditDealScreen(
                                      deal: state.deal,
                                    );
                                  }));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColor.backgroundColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  dealBloc.add(
                                      DeleteDealEvent(id: state.deal.id ?? ''));
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColor.red,
                                ),
                              ),
                            ],
                          ),
                          titleAndInput(
                            title:
                                "${AppLocalizations.of(context).translate('اسم الصفقة')} : ",
                            input: state.deal.name,
                          ),
                          titleAndInput(
                            title:
                                "${AppLocalizations.of(context).translate('اسم البائع')} : ",
                            input: state.deal.companyName,
                          ),
                          titleAndInput(
                            title:
                                "${AppLocalizations.of(context).translate('تاريخ بدء الصفقة')} : ",
                            input: convertDateToString(state.deal.startDate),
                          ),
                          titleAndInput(
                            title:
                                "${AppLocalizations.of(context).translate('تاريخ انتهاء الصفقة')}: ",
                            input: convertDateToString(state.deal.endDate),
                          ),
                          titleAndInput(
                            title:
                                "${AppLocalizations.of(context).translate('السعر قبل')}:",
                            input: state.deal.prevPrice.toString(),
                          ),
                          titleAndInput(
                            title:
                                "${AppLocalizations.of(context).translate('السعر بعد')} : ",
                            input: state.deal.currentPrice.toString(),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.h),
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: () {
                                  // Get.to(ViewDetailsDeals(dealsModel: dealsModel));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.backgroundColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    //shadowColor: Colors.black,
                                    //  elevation: 5
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    textStyle: const TextStyle(fontSize: 15)),
                                child: Text(AppLocalizations.of(context)
                                    .translate('اشتري الان'))),
                          ),
                          SizedBox(
                            height: 100.h,
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Padding titleAndInput({required String title, required String input}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      // height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: AppColor.backgroundColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 190,
              child: Text(
                input,
                style: TextStyle(
                  color: AppColor.mainGrey,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

myspec(context, String feature, String details, Color colorbackground,
    Color colortext) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(
      bottom: 5,
      top: 5,
      right: 10,
      left: 10,
    ),
    child: RichText(
      text: TextSpan(
          style: TextStyle(fontSize: 17.sp, color: colorbackground),
          children: <TextSpan>[
            TextSpan(text: feature),
            TextSpan(
              text: details,
              style: TextStyle(color: colortext, fontSize: 13.sp),
            )
          ]),
    ),
  );
}
