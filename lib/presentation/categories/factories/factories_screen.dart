import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/factories/blocs/factories_bloc/factories_bloc.dart';
import 'package:netzoon/presentation/categories/widgets/factories_categories.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class FactoryScreen extends StatefulWidget {
  const FactoryScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<FactoryScreen> createState() => _FactoryScreenState();
}

class _FactoryScreenState extends State<FactoryScreen> {
  final factoryBloc = sl<FactoriesBloc>();

  @override
  void initState() {
    factoryBloc.add(GetFactoryCompaniesEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          isHome: false,
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
              } else if (state is FactoryCompaniesSuccess) {
                return state.companies.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).translate('no_items'),
                          style: const TextStyle(
                              color: AppColor.backgroundColor, fontSize: 23),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Text(
                              //     " المصانع",
                              //     style: TextStyle(fontSize: 20.sp, color: Colors.black),
                              //   ),
                              // ),
                              Expanded(
                                child: ViewFactoriesWidget(
                                  factory: state.companies,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              }
              return Container();
            },
          )),
    );
  }
}
