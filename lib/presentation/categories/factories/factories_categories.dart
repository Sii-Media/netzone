import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/factories/blocs/factories_bloc/factories_bloc.dart';
import 'package:netzoon/presentation/categories/factories/factories_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class FactoriesCategoryScreen extends StatefulWidget {
  const FactoriesCategoryScreen({super.key});

  @override
  State<FactoriesCategoryScreen> createState() =>
      _FactoriesCategoryScreenState();
}

class _FactoriesCategoryScreenState extends State<FactoriesCategoryScreen> {
  final factoryBloc = sl<FactoriesBloc>();

  @override
  void initState() {
    factoryBloc.add(GetAllFactoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: RefreshIndicator(
        onRefresh: () async {
          factoryBloc.add(GetAllFactoriesEvent());
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BackgroundWidget(
              widget: BlocBuilder<FactoriesBloc, FactoriesState>(
            bloc: factoryBloc,
            builder: (context, state) {
              if (state is FactoriesInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                );
              } else if (state is FactoriesFailure) {
                final failure = state.message;
                return Center(
                  child: Text(
                    failure,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              } else if (state is FactoriesSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.factories.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return FactoryScreen(
                                      id: state.factories[index].id,
                                    );
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
                                  AppLocalizations.of(context)
                                      .translate(state.factories[index].title),
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
          )),
        ),
      ),
    ));
  }
}
