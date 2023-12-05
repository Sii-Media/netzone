import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/categories/free_zoon/freezone_company_profile_screen.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';

import '../../injection_container.dart';
import '../advertising/advertising_details.dart';
import '../categories/factories/factory_profile_screen.dart';
import '../categories/local_company/local_company_bloc/local_company_bloc.dart';
import '../categories/local_company/local_company_profile.dart';
import '../categories/real_estate/blocs/real_estate/real_estate_bloc.dart';
import '../categories/real_estate/screens/real_estate_company_profile_screen.dart';
import '../categories/users/blocs/users_bloc/users_bloc.dart';
import '../categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import '../core/constant/colors.dart';
import '../core/widgets/vehicle_details.dart';
import '../data/cars.dart';
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
    'free_zone_companies',
    'Products',
    'cars',
    'advertiments',
    'civil_aircraft',
    'factories',
    'real_estate',
  ];
  late String selectedCategory;
  late String searchText;
  String? selectedCarType;
  String? selectedCat;
  String? data = '';
  List<dynamic> items = [];

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
      if (cat == 'local_companies' ||
          cat == 'free_zone_companies' ||
          cat == 'factories' ||
          cat == 'real_estate') {
        filteredItems = items
            .where((item) =>
                item.username.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      } else if (cat == 'cars') {
        filteredItems = items
            .where((item) =>
                item.name.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      } else {
        filteredItems = items
            .where((item) =>
                item.name.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  final factoryBloc = sl<UsersBloc>();
  final freeZoneBloc = sl<UsersBloc>();
  final productBloc = sl<ElecDevicesBloc>();
  final localCompanyBloc = sl<LocalCompanyBloc>();
  final adsBloc = sl<AdsBlocBloc>();
  final vehicleBloc = sl<VehicleBloc>();
  final estateBloc = sl<RealEstateBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
            size: 22.sp,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).translate('Search Page'),
          style: const TextStyle(color: AppColor.backgroundColor),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
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
                Column(
                  children: [
                    Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: AppColor.secondGrey.withOpacity(0.3)),
                        ),
                      ),
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          String cat = categories[index];
                          bool isSelected = selectedCategory == cat;

                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.r),
                            // width: 120.w,
                            // margin: EdgeInsets.symmetric(horizontal: 1),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = (isSelected ? null : cat)!;
                                  filteredItems = [];
                                  if (cat == 'Products') {
                                    productBloc.add(GetAllProductsEvent());
                                  } else if (cat == 'local_companies') {
                                    localCompanyBloc.add(
                                        const GetLocalCompaniesEvent(
                                            userType: 'local_company'));
                                  } else if (cat == 'free_zone_companies') {
                                    freeZoneBloc.add(const GetUsersListEvent(
                                        userType: 'freezone'));
                                  } else if (cat == 'real_estate') {
                                    estateBloc
                                        .add(GetRealEstateCompaniesEvent());
                                  } else if (cat == 'factories') {
                                    factoryBloc.add(const GetUsersListEvent(
                                        userType: 'factory'));
                                  } else if (cat == 'advertiments') {
                                    adsBloc.add(const GetAllAdsEvent());
                                  } else if (cat == 'cars') {
                                    vehicleBloc.add(const GetAllCarsEvent());
                                  } else if (cat == 'civil_aircraft') {
                                    vehicleBloc.add(GetAllNewPlanesEvent());
                                  }
                                  controller.text = '';
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
                  ],
                ),

                const SizedBox(height: 16.0),
                if (selectedCategory == 'Products') productBlocWidget(),
                if (selectedCategory == 'local_companies')
                  localCompanyBlocWidget(),
                if (selectedCategory == 'free_zone_companies')
                  freeZoneBlocWidget(),
                if (selectedCategory == 'real_estate')
                  realEstateCompanyBlocWidget(),
                if (selectedCategory == 'factories') factoryBlocWidget(),
                if (selectedCategory == 'advertiments') adsBlocWidget(),
                // if (selectedCategory == 'cars') carsBlocWidget(),
                if (selectedCategory == 'cars') carsWidget(),

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
                filteredItems.isEmpty
                    // ? Text(
                    //     searchText.isEmpty ? '' : 'no_data',
                    //     style: TextStyle(color: Colors.red),
                    //   )
                    ? Text(
                        searchText.isEmpty
                            ? ''
                            : AppLocalizations.of(context)
                                .translate('no_items'),
                        style: const TextStyle(color: AppColor.backgroundColor))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (selectedCategory == 'Products') {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return ProductDetailScreen(
                                        item: filteredItems[index].id);
                                  }));
                                } else if (selectedCategory ==
                                    'local_companies') {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return LocalCompanyProfileScreen(
                                        localCompany: filteredItems[index]);
                                  }));
                                } else if (selectedCategory ==
                                    'free_zone_companies') {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return FreezoneCompanyProfileScreen(
                                        user: filteredItems[index]);
                                  }));
                                } else if (selectedCategory == 'real_estate') {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return RealEstateCompanyProfileScreen(
                                        user: filteredItems[index]);
                                  }));
                                } else if (selectedCategory == 'factories') {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return FactoryProfileScreen(
                                        user: filteredItems[index]);
                                  }));
                                } else if (selectedCategory == 'advertiments') {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return AdvertismentDetalsScreen(
                                        adsId: filteredItems[index].id);
                                  }));
                                } else if (selectedCategory == 'cars') {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return VehicleDetailsScreen(
                                        vehicle: filteredItems[index]);
                                  }));
                                } else if (selectedCategory ==
                                    'civil_aircraft') {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return VehicleDetailsScreen(
                                        vehicle: filteredItems[index]);
                                  }));
                                }
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 5),
                                      color: AppColor.backgroundColor
                                          .withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(
                                    selectedCategory == 'local_companies' ||
                                            selectedCategory ==
                                                'free_zone_companies' ||
                                            selectedCategory == 'factories' ||
                                            selectedCategory == 'real_estate'
                                        ? filteredItems[index].username
                                        : filteredItems[index].name,
                                    style: TextStyle(
                                        color: AppColor.backgroundColor,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  leading: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 22.sp,
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
            hideSuggestionsOnKeyboardHide: false,
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

  Widget carsWidget() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10).r,
          // Add some padding and a background color
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColor.backgroundColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColor.black,
            ),
          ),
          child: DropdownButton<String>(
            value: selectedCarType,
            hint: Text(
              'Select car type',
              style: TextStyle(fontSize: 10.sp),
            ),
            onChanged: (value) {
              setState(() {
                selectedCarType = value;
                selectedCat =
                    null; // Reset the selected category when the car type changes
              });
            },
            items: carTypes.map((carType) {
              return DropdownMenuItem<String>(
                enabled: true,
                value: carType.name,
                child: Text(
                  carType.name,
                  style: TextStyle(fontSize: 10.sp),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        BlocBuilder<VehicleBloc, VehicleState>(
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

              return selectedCarType != null
                  ? TypeAheadField(
                      hideSuggestionsOnKeyboardHide: false,
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
                        // return state.vehilces.where((item) =>
                        //     item.name.toLowerCase().contains(pattern.toLowerCase()));

                        List<String> c = carTypes
                            .firstWhere(
                                (carType) => carType.name == selectedCarType)
                            .categories;
                        return c.where((item) =>
                            item.toLowerCase().contains(pattern.toLowerCase()));
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        setState(() {
                          searchText = suggestion;
                        });
                        controller.text = searchText;
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                      },
                    )
                  : const SizedBox();
            }
            return Container();
          },
        ),
      ],
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
            hideSuggestionsOnKeyboardHide: false,
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
            hideSuggestionsOnKeyboardHide: false,
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
            hideSuggestionsOnKeyboardHide: false,
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

  BlocBuilder<UsersBloc, UsersState> factoryBlocWidget() {
    return BlocBuilder<UsersBloc, UsersState>(
      bloc: factoryBloc,
      builder: (context, state) {
        if (state is GetUsersInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.backgroundColor,
            ),
          );
        } else if (state is GetUsersFailure) {
          final failure = state.message;
          return Center(
            child: Text(
              failure,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        } else if (state is GetUsersSuccess) {
          items = state.users;
          return TypeAheadField(
            hideSuggestionsOnKeyboardHide: false,
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
              return state.users.where((item) =>
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

  BlocBuilder<UsersBloc, UsersState> freeZoneBlocWidget() {
    return BlocBuilder<UsersBloc, UsersState>(
      bloc: freeZoneBloc,
      builder: (context, state) {
        if (state is GetUsersInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.backgroundColor,
            ),
          );
        } else if (state is GetUsersFailure) {
          final failure = state.message;
          return Center(
            child: Text(
              failure,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        } else if (state is GetUsersSuccess) {
          items = state.users;
          return TypeAheadField(
            hideSuggestionsOnKeyboardHide: false,
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
              return state.users.where((item) =>
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

  BlocBuilder<RealEstateBloc, RealEstateState> realEstateCompanyBlocWidget() {
    return BlocBuilder<RealEstateBloc, RealEstateState>(
      bloc: estateBloc,
      builder: (context, state) {
        if (state is GetRealEstateInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.backgroundColor,
            ),
          );
        } else if (state is GetRealEstateFailure) {
          final failure = state.message;
          return Center(
            child: Text(
              failure,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        } else if (state is GetRealEstateCompaniesSuccess) {
          items = state.companies;
          return TypeAheadField(
            hideSuggestionsOnKeyboardHide: false,
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
            hideSuggestionsOnKeyboardHide: false,
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
