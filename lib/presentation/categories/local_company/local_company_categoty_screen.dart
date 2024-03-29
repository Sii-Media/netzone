import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class LocalCompanyCategoryScreen extends StatefulWidget {
  const LocalCompanyCategoryScreen({super.key});

  @override
  State<LocalCompanyCategoryScreen> createState() =>
      _LocalCompanyCategoryScreenState();
}

class _LocalCompanyCategoryScreenState
    extends State<LocalCompanyCategoryScreen> {
  final localCompanyBloc = sl<LocalCompanyBloc>();

  @override
  void initState() {
    localCompanyBloc.add(GetAllLocalCompaniesCategoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () async {
            localCompanyBloc.add(GetAllLocalCompaniesCategoriesEvent());
          },
          color: AppColor.white,
          backgroundColor: AppColor.backgroundColor,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: BackgroundWidget(
              isHome: false,
              widget: BlocBuilder<LocalCompanyBloc, LocalCompanyState>(
                bloc: localCompanyBloc,
                builder: (context, state) {
                  if (state is GetAllLocalComapaniesCategoriesInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    );
                  } else if (state is GetAllLocalComapaniesCategoriesFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is GetAllLocalComapaniesCategoriesSuccess) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.localCompanyCategories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 20),
                              child: GestureDetector(
                                onTap: () {},
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
                                    state.localCompanyCategories[index].nameEn,
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
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
