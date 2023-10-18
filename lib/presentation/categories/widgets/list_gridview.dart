import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/categories.dart';
import 'package:netzoon/presentation/categories/customs_screen/customs_category.dart';
import 'package:netzoon/presentation/categories/factories/factories_categories.dart';
import 'package:netzoon/presentation/categories/governmental/govermental_category_screen.dart';
import 'package:netzoon/presentation/categories/local_company/local_companies.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_companies_list_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/data/categories.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../core/blocs/country_bloc/country_bloc.dart';
import '../../home/widgets/not_now_alert.dart';
import '../delivery_company/screens/delivery_companies_list_screen.dart';
import '../free_zoon/freezone_companies_list_screen.dart';
import '../users/screens/users_list_screen.dart';
import '../vehicles/screens/vehicles_companies_screen.dart';

class ListGridView extends StatefulWidget {
  const ListGridView({Key? key}) : super(key: key);

  @override
  State<ListGridView> createState() => _ListGridViewState();
}

class _ListGridViewState extends State<ListGridView> {
  late final CountryBloc countryBloc;

  @override
  void initState() {
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categories = cat;
    return BlocBuilder<CountryBloc, CountryState>(
      bloc: countryBloc,
      builder: (context, state) {
        if (state is CountryInitial) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  // height: 70.sp,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('category'),
                        style: TextStyle(fontSize: 25.sp, color: Colors.black),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Icon(
                        Icons.arrow_downward_sharp,
                        color: Colors.black,
                        size: 15.sp,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: GridCategory(
                              category: categories[index], state: state),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 90.h,
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class GridCategory extends StatelessWidget {
  const GridCategory({super.key, required this.category, required this.state});

  final Category category;
  final CountryInitial state;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: () {
          if (category.name == 'local_companies') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const GovernmentalCompanies(
                    userType: 'local_company',
                  );
                },
              ),
            );
          } else if (category.name == 'free_zone_companies') {
            if (state.selectedCountry == 'AE') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const FreeZoneCompaniesListScreen();
                  },
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      AppLocalizations.of(context).translate('sorry'),
                      style: const TextStyle(color: AppColor.red),
                    ),
                    content: Text(
                      AppLocalizations.of(context)
                          .translate('This is not Available now'),
                      style: const TextStyle(color: AppColor.red),
                    ),
                    actions: [
                      ElevatedButton(
                        child: Text(
                          AppLocalizations.of(context).translate('ok'),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          } else if (category.name == 'customs') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const CustomsCategoryScreen();
                },
              ),
            );
          } else if (category.name == 'government_institutions') {
            if (state.selectedCountry == 'AE') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const GovermentalCategoryScreen();
                  },
                ),
              );
            } else {
              notNowAlert(context);
            }
          } else if (category.name == 'factories') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const FactoriesCategoryScreen();
                },
              ),
            );
          } else if (category.name == 'civil_aircraft') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const VehiclesCompaniesScreen(
                    type: 'planes',
                  );
                },
              ),
            );
          } else if (category.name == 'cars') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const VehiclesCompaniesScreen(
                    type: 'cars',
                  );
                },
              ),
            );
          } else if (category.name == 'sea_companies') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const VehiclesCompaniesScreen(
                    type: 'sea_companies',
                  );
                },
              ),
            );
          } else if (category.name == 'users') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const UsersListScreen();
                },
              ),
            );
          } else if (category.name == 'real_estate') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const RealEstateCompaniesListScreen();
                },
              ),
            );
          } else if (category.name == 'delivery_companies') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const DeliveryCompaniesListScreen();
                },
              ),
            );
          } else if (category.name == 'traders') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const GovernmentalCompanies(
                    userType: 'trader',
                  );
                },
              ),
            );
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            category.name == 'government_institutions'
                ? state.selectedCountry == 'AE'
                    ? Image.asset(
                        category.url,
                        fit: BoxFit.fitHeight,
                        height: 160.h,
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxLJx8scm0s4QuXRS-OO2LgaJz3zrQT2qVgE9kvAc&s',
                        fit: BoxFit.fitHeight,
                        height: 160.h,
                      )
                : Image.asset(
                    category.url,
                    fit: BoxFit.fitHeight,
                    height: 160.h,
                  ),
            Container(
              height: 50.h,
              width: double.infinity,
              color: AppColor.backgroundColor.withOpacity(0.8),
              alignment: Alignment.center,
              child: Text(
                textAlign: TextAlign.center,
                AppLocalizations.of(context).translate(category.name),
                style: TextStyle(fontSize: 15.sp, color: AppColor.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
