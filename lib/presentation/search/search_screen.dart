import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';

import '../../injection_container.dart';
import '../advertising/advertising_details.dart';
import '../categories/local_company/local_company_bloc/local_company_bloc.dart';
import '../categories/local_company/local_company_profile.dart';
import '../categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import '../core/constant/colors.dart';
import '../core/widgets/vehicle_details.dart';
import '../home/blocs/elec_devices/elec_devices_bloc.dart';
import '../utils/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> categories = [
    'local_companies',
    'Products',
    'cars',
    'advertiments',
    'civil_aircraft',
  ];
  late String selectedCategory;
  late String searchText;

  List<dynamic> items = [
    // Add more items as needed
  ];

  List<dynamic> filteredItems = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    selectedCategory = '';
    searchText = '';
    super.initState();
    filteredItems = [];
  }

  void filterItems(String cat) {
    setState(() {
      if (cat == 'local_companies') {
        filteredItems = items
            .where((item) =>
                item.username.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      } else {
        filteredItems = items
            .where((item) =>
                item.name.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  final productBloc = sl<ElecDevicesBloc>();
  final localCompanyBloc = sl<LocalCompanyBloc>();
  final adsBloc = sl<AdsBlocBloc>();
  final vehicleBloc = sl<VehicleBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).translate('Search Page'),
          style: TextStyle(color: AppColor.backgroundColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)
                  .translate('Choose what you want to search for'),
              style: const TextStyle(
                color: AppColor.backgroundColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 60.h,
              decoration: BoxDecoration(
                border: Border(
                  bottom:
                      BorderSide(color: AppColor.secondGrey.withOpacity(0.3)),
                ),
              ),
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  String cat = categories[index];
                  bool isSelected = selectedCategory == cat;

                  return SizedBox(
                    width: 105.w,
                    // margin: EdgeInsets.symmetric(horizontal: 1),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = (isSelected ? null : cat)!;
                          if (cat == 'Products') {
                            productBloc.add(GetAllProductsEvent());
                          } else if (cat == 'local_companies') {
                            localCompanyBloc.add(GetLocalCompaniesEvent(
                                userType: 'local_company'));
                          } else if (cat == 'advertiments') {
                            adsBloc.add(GetAllAdsEvent());
                          } else if (cat == 'cars') {
                            vehicleBloc.add(GetAllCarsEvent());
                          } else if (cat == 'civil_aircraft') {
                            vehicleBloc.add(GetAllNewPlanesEvent());
                          }
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate(cat),
                            style: TextStyle(
                              fontSize: isSelected ? 13.sp : 12.sp,
                              color: isSelected
                                  ? AppColor.backgroundColor
                                  : AppColor.secondGrey,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Divider(
                            color: isSelected
                                ? AppColor.backgroundColor
                                : AppColor.secondGrey.withOpacity(0.3),
                            thickness: isSelected ? 2 : 1,
                            endIndent: 40,
                            indent: 40,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // DropdownButtonFormField(
            //   // value: selectedCategory,
            //   onChanged: (value) {
            //     if (value == 'Products') {
            //       productBloc.add(GetAllProductsEvent());
            //     } else if (value == 'local_companies') {
            //       localCompanyBloc.add(GetAllLocalCompaniesEvent());
            //     } else if (value == 'advertiments') {
            //       adsBloc.add(GetAllAdsEvent());
            //     } else if (value == 'cars') {
            //       vehicleBloc.add(GetAllCarsEvent());
            //     } else if (value == 'civil_aircraft') {
            //       vehicleBloc.add(GetAllNewPlanesEvent());
            //     }
            //     setState(() {
            //       selectedCategory = value as String;
            //     });
            //   },
            //   items: categories.map((category) {
            //     return DropdownMenuItem(
            //       value: category,
            //       child: Text(AppLocalizations.of(context).translate(category)),
            //     );
            //   }).toList(),
            //   decoration: InputDecoration(
            //     labelText: 'Category',
            //   ),
            // ),
            const SizedBox(height: 16.0),
            if (selectedCategory == 'Products') productBlocWidget(),
            if (selectedCategory == 'local_companies') localCompanyBlocWidget(),
            if (selectedCategory == 'advertiments') adsBlocWidget(),
            if (selectedCategory == 'cars') carsBlocWidget(),
            if (selectedCategory == 'civil_aircraft') aircraftBlocWidget(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  AppColor.backgroundColor,
                ),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                )),
              ),
              onPressed: () {
                filterItems(selectedCategory);
              },
              child: Text(AppLocalizations.of(context).translate('Search')),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (selectedCategory == 'Products') {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ProductDetailScreen(
                              item: filteredItems[index].id);
                        }));
                      } else if (selectedCategory == 'local_companies') {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return LocalCompanyProfileScreen(
                              localCompany: filteredItems[index]);
                        }));
                      } else if (selectedCategory == 'advertiments') {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return AdvertismentDetalsScreen(
                              adsId: filteredItems[index].id);
                        }));
                      } else if (selectedCategory == 'cars') {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return VehicleDetailsScreen(
                              vehicle: filteredItems[index]);
                        }));
                      } else if (selectedCategory == 'civil_aircraft') {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return VehicleDetailsScreen(
                              vehicle: filteredItems[index]);
                        }));
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 5),
                            color: AppColor.backgroundColor.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          selectedCategory == 'local_companies'
                              ? filteredItems[index].username
                              : filteredItems[index].name,
                          style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        leading: const Icon(
                          Icons.arrow_forward_ios,
                          size: 22,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder<VehicleBloc, VehicleState> aircraftBlocWidget() {
    return BlocBuilder<VehicleBloc, VehicleState>(
      bloc: vehicleBloc,
      builder: (context, state) {
        if (state is VehicleInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.backgroundColor,
            ),
          );
        } else if (state is VehicleFailure) {
          final failure = state.message;
          return Center(
            child: Text(
              failure,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        } else if (state is VehicleSuccess) {
          items = state.vehilces;
          return TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
            suggestionsCallback: (pattern) {
              return state.vehilces.where((item) =>
                  item.name.toLowerCase().contains(pattern.toLowerCase()));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.name),
              );
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                searchText = suggestion.name;
              });
              controller.text = searchText;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  BlocBuilder<VehicleBloc, VehicleState> carsBlocWidget() {
    return BlocBuilder<VehicleBloc, VehicleState>(
      bloc: vehicleBloc,
      builder: (context, state) {
        if (state is VehicleInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.backgroundColor,
            ),
          );
        } else if (state is VehicleFailure) {
          final failure = state.message;
          return Center(
            child: Text(
              failure,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        } else if (state is VehicleSuccess) {
          items = state.vehilces;
          return TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
            suggestionsCallback: (pattern) {
              return state.vehilces.where((item) =>
                  item.name.toLowerCase().contains(pattern.toLowerCase()));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.name),
              );
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                searchText = suggestion.name;
              });
              controller.text = searchText;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  BlocBuilder<AdsBlocBloc, AdsBlocState> adsBlocWidget() {
    return BlocBuilder<AdsBlocBloc, AdsBlocState>(
      bloc: adsBloc,
      builder: (context, state) {
        if (state is AdsBlocInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.backgroundColor,
            ),
          );
        } else if (state is AdsBlocFailure) {
          final failure = state.message;
          return Center(
            child: Text(
              failure,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        } else if (state is AdsBlocSuccess) {
          items = state.ads;
          return TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
            suggestionsCallback: (pattern) {
              return state.ads.where((item) =>
                  item.name.toLowerCase().contains(pattern.toLowerCase()));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.name),
              );
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                searchText = suggestion.name;
              });
              controller.text = searchText;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  BlocBuilder<LocalCompanyBloc, LocalCompanyState> localCompanyBlocWidget() {
    return BlocBuilder<LocalCompanyBloc, LocalCompanyState>(
      bloc: localCompanyBloc,
      builder: (context, state) {
        if (state is LocalCompanyInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.backgroundColor,
            ),
          );
        } else if (state is LocalCompanyFailure) {
          final failure = state.message;
          return Center(
            child: Text(
              failure,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        } else if (state is GetLocalCompaniesSuccess) {
          items = state.companies;
          return TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
            suggestionsCallback: (pattern) {
              return state.companies.where((item) =>
                  item.username!.toLowerCase().contains(pattern.toLowerCase()));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.username ?? ''),
              );
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                searchText = suggestion.username ?? '';
              });
              controller.text = searchText;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  BlocBuilder<ElecDevicesBloc, ElecDevicesState> productBlocWidget() {
    return BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
      bloc: productBloc,
      builder: (context, state) {
        if (state is ElecDevicesInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.backgroundColor,
            ),
          );
        } else if (state is ElecDevicesFailure) {
          final failure = state.message;
          return Center(
            child: Text(
              failure,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        } else if (state is ElecCategoryProductSuccess) {
          items = state.categoryProducts;
          return TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
            suggestionsCallback: (pattern) {
              return state.categoryProducts.where((item) =>
                  item.name.toLowerCase().contains(pattern.toLowerCase()));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.name),
              );
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                searchText = suggestion.name;
              });
              controller.text = searchText;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
