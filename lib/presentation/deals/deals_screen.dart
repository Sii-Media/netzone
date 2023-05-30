import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/deals/blocs/deals_category/deals_categoty_bloc.dart';
import 'package:netzoon/presentation/tenders/categories.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class DealsCategoriesScreen extends StatefulWidget {
  const DealsCategoriesScreen({super.key, required this.title});

  final String title;

  @override
  State<DealsCategoriesScreen> createState() => _DealsCategoriesScreenState();
}

class _DealsCategoriesScreenState extends State<DealsCategoriesScreen> {
  final dealBloc = sl<DealsCategotyBloc>();

  @override
  void initState() {
    dealBloc.add(GetDealsCategoryEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: BackgroundWidget(
          widget: RefreshIndicator(
            onRefresh: () async {
              dealBloc.add(GetDealsCategoryEvent());
            },
            child: BlocBuilder<DealsCategotyBloc, DealsCategotyState>(
              bloc: dealBloc,
              builder: (context, state) {
                if (state is DealsCategotyInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  );
                } else if (state is DealsCategotyFailure) {
                  final failure = state.message;
                  return Center(
                    child: Text(
                      failure,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 25.sp,
                      ),
                    ),
                  );
                } else if (state is DealsCategotySuccess) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context).translate(widget.title),
                          style:
                              TextStyle(fontSize: 20.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.0.h),
                          child: SizedBox(
                            // height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.dealsCat.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  child: Categories(
                                    dealsCategory: state.dealsCat[index],
                                    category: widget.title,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
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
