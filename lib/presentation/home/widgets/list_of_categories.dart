import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/categories.dart';
import 'package:netzoon/presentation/categories/customs_screen/customs_category.dart';
import 'package:netzoon/presentation/categories/factories/factories_categories.dart';
import 'package:netzoon/presentation/categories/local_company/local_companies.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_companies_list_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../categories/delivery_company/screens/delivery_companies_list_screen.dart';
import '../../categories/free_zoon/freezone_companies_list_screen.dart';
import '../../categories/governmental/govermental_category_screen.dart';
import '../../categories/users/screens/users_list_screen.dart';
import '../../categories/vehicles/screens/vehicles_companies_screen.dart';
import '../../core/blocs/country_bloc/country_bloc.dart';
import 'not_now_alert.dart';

class ListOfCategories extends StatefulWidget {
  const ListOfCategories({
    super.key,
    required this.categories,
  });
  final List<Category> categories;

  @override
  State<ListOfCategories> createState() => _ListOfCategoriesState();
}

class _ListOfCategoriesState extends State<ListOfCategories> {
  late final CountryBloc countryBloc;

  @override
  void initState() {
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<CountryBloc, CountryState>(
        bloc: countryBloc,
        builder: (context, state) {
          if (state is CountryInitial) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(30)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: InkWell(
                          onTap: () {
                            if (widget.categories[index].name ==
                                'local_companies') {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const GovernmentalCompanies(
                                  userType: 'local_company',
                                );
                              }));
                            } else if (widget.categories[index].name ==
                                'free_zone_companies') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const FreeZoneCompaniesListScreen();
                                  },
                                ),
                              );
                              // if (state.selectedCountry == 'AE') {
                              //   Navigator.of(context).push(
                              //     MaterialPageRoute(
                              //       builder: (context) {
                              //         return const CategoriesFreeZone();
                              //       },
                              //     ),
                              //   );
                              // } else {
                              //   showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return AlertDialog(
                              //         title: Text(
                              //           AppLocalizations.of(context)
                              //               .translate('sorry'),
                              //           style: const TextStyle(
                              //               color: AppColor.red),
                              //         ),
                              //         content: Text(
                              //           AppLocalizations.of(context).translate(
                              //               'This is not Available now'),
                              //           style: const TextStyle(
                              //               color: AppColor.red),
                              //         ),
                              //         actions: [
                              //           ElevatedButton(
                              //             child: Text(
                              //               AppLocalizations.of(context)
                              //                   .translate('ok'),
                              //             ),
                              //             onPressed: () {
                              //               Navigator.of(context).pop();
                              //             },
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   );
                              // }
                            } else if (widget.categories[index].name ==
                                'customs') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const CustomsCategoryScreen();
                                  },
                                ),
                              );
                            } else if (widget.categories[index].name ==
                                'government_institutions') {
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
                            } else if (widget.categories[index].name ==
                                'factories') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const FactoriesCategoryScreen();
                                  },
                                ),
                              );
                            } else if (widget.categories[index].name ==
                                'traders') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const GovernmentalCompanies(
                                      userType: 'trader',
                                    );
                                  },
                                ),
                              );
                            } else if (widget.categories[index].name ==
                                'civil_aircraft') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const VehiclesCompaniesScreen(
                                      type: 'planes',
                                    );
                                  },
                                ),
                              );
                            } else if (widget.categories[index].name ==
                                'cars') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const VehiclesCompaniesScreen(
                                      type: 'cars',
                                    );
                                  },
                                ),
                              );
                            } else if (widget.categories[index].name ==
                                'sea_companies') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const VehiclesCompaniesScreen(
                                      type: 'sea_companies',
                                    );
                                  },
                                ),
                              );
                            } else if (widget.categories[index].name ==
                                'users') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const UsersListScreen();
                                  },
                                ),
                              );
                            } else if (widget.categories[index].name ==
                                'real_estate') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const RealEstateCompaniesListScreen();
                                  },
                                ),
                              );
                            } else if (widget.categories[index].name ==
                                'delivery_companies') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const DeliveryCompaniesListScreen();
                                  },
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 151,
                                    spreadRadius: 300,
                                    offset: Offset(10, 30))
                              ],
                            ),
                            height: 300.h,
                            child: Stack(
                              children: [
                                widget.categories[index].name ==
                                        'government_institutions'
                                    ? state.selectedCountry == 'AE'
                                        ? Image.asset(
                                            widget.categories[index].url,
                                            fit: BoxFit.fill,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl:
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxLJx8scm0s4QuXRS-OO2LgaJz3zrQT2qVgE9kvAc&s',
                                            fit: BoxFit.fill,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                          )
                                    : Image.asset(
                                        widget.categories[index].url,
                                        fit: BoxFit.fill,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      ),
                                // CachedNetworkImage(
                                //   imageUrl: categories[index].url,
                                //   fit: BoxFit.fill,
                                //   height: MediaQuery.of(context).size.height,
                                // ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 36.h,
                                    color: AppColor.backgroundColor
                                        .withOpacity(0.8),
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        AppLocalizations.of(context).translate(
                                            widget.categories[index].name),
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
