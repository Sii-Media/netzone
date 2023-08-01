import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/data/deals_categories.dart';
import 'package:netzoon/presentation/data/tenders_categories.dart';
import 'package:netzoon/presentation/tenders/blocs/tendersCategory/tender_cat_bloc.dart';
import 'package:netzoon/presentation/tenders/categories.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class TenderCategoriesScreen extends StatefulWidget {
  const TenderCategoriesScreen({super.key, required this.title});
  final String title;
  @override
  State<TenderCategoriesScreen> createState() => _TenderCategoriesScreenState();
}

class _TenderCategoriesScreenState extends State<TenderCategoriesScreen> {
  List<dynamic> list = [];
  final tenderBloc = sl<TenderCatBloc>();

  @override
  void initState() {
    if (widget.title == 'فئات الصفقات') {
      list = dealsCategories;
    } else {
      tenderBloc.add(GetAllTendersCatEvent());
      list = tendersCategrories;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: BackgroundWidget(
          isHome: false,
          widget: RefreshIndicator(
            onRefresh: () async {
              tenderBloc.add(GetAllTendersCatEvent());
            },
            child: BlocBuilder<TenderCatBloc, TenderCatState>(
              bloc: tenderBloc,
              builder: (context, state) {
                if (state is TenderCatInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  );
                } else if (state is TenderCatFailure) {
                  final failure = state.message;
                  return Center(
                    child: Text(
                      failure,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else if (state is TenderCatSuccess) {
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
                              itemCount: state.tenderCat.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  child: widget.title == 'فئات الصفقات'
                                      ? Categories(
                                          dealsCategory: list[index],
                                          category: widget.title,
                                        )
                                      : Categories(
                                          tendersCategory:
                                              state.tenderCat[index],
                                          category: widget.title,
                                        ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60.h,
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
