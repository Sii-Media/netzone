import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/categories/users/screens/users_profile_screen.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/profile/blocs/get_user/get_user_bloc.dart';

import '../../../injection_container.dart';
import '../../categories/local_company/local_company_profile.dart';
import '../../core/blocs/country_bloc/country_bloc.dart';
import '../../core/constant/colors.dart';
import '../../core/helpers/get_currency_of_country.dart';
import '../../home/blocs/elec_devices/elec_devices_bloc.dart';
import '../../utils/app_localizations.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen>
    with ScreenLoader<AllProductsScreen> {
  final producBloc = sl<ElecDevicesBloc>();
  final addBloc = sl<GetUserBloc>();
  late final CountryBloc countryBloc;

  List<CategoryProducts> selectedProducts = [];
  @override
  void initState() {
    super.initState();
    producBloc.add(GetSelectableProductsEvent());
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        title: Text(
          AppLocalizations.of(context).translate('all_products'),
          style: const TextStyle(
            color: AppColor.backgroundColor,
          ),
        ),
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
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocListener<GetUserBloc, GetUserState>(
            bloc: addBloc,
            listener: (context, state) {
              if (state is AddToSelectedProductsInProgress) {
                startLoading();
              } else if (state is AddToSelectedProductsFailure) {
                stopLoading();

                final failure = state.message;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      failure,
                      style: const TextStyle(
                        color: AppColor.white,
                      ),
                    ),
                    backgroundColor: AppColor.red,
                  ),
                );
              } else if (state is AddToSelectedProductsSuccess) {
                stopLoading();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    state.message,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ));
                Navigator.of(context).pop();
              }
            },
            child: BlocBuilder<CountryBloc, CountryState>(
              bloc: countryBloc,
              builder: (context, countryState) {
                return BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
                  bloc: producBloc,
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
                      return RefreshIndicator(
                        onRefresh: () async {
                          producBloc.add(GetAllProductsEvent());
                        },
                        color: AppColor.white,
                        backgroundColor: AppColor.backgroundColor,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.categoryProducts.length,
                          itemBuilder: (context, index) {
                            final product = state.categoryProducts[index];
                            final isSelected =
                                selectedProducts.contains(product);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    state.categoryProducts[index].name,
                                    style: TextStyle(
                                        color: AppColor.backgroundColor,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 140.w,
                                        child: Text(
                                          state.categoryProducts[index]
                                              .description,
                                          maxLines: 3,
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: AppColor.secondGrey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 70.w,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (state
                                                          .categoryProducts[
                                                              index]
                                                          .owner
                                                          .userType ==
                                                      'user') {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return UsersProfileScreen(
                                                          userId: state
                                                              .categoryProducts[
                                                                  index]
                                                              .owner
                                                              .id);
                                                    }));
                                                  } else if (state
                                                          .categoryProducts[
                                                              index]
                                                          .owner
                                                          .userType ==
                                                      'local_company') {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return LocalCompanyProfileScreen(
                                                          id: state
                                                              .categoryProducts[
                                                                  index]
                                                              .owner
                                                              .id);
                                                    }));
                                                  }
                                                },
                                                child: Text(
                                                  state.categoryProducts[index]
                                                          .owner.username ??
                                                      '',
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: AppColor.colorOne,
                                                      fontSize: 11.sp),
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: AppColor
                                                          .backgroundColor),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${state.categoryProducts[index].price}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColor.red,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          getCurrencyFromCountry(
                                                        countryState
                                                            .selectedCountry,
                                                        context,
                                                      ),
                                                      style: TextStyle(
                                                          color: AppColor.red,
                                                          fontSize: 8.sp),
                                                    )
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  tileColor: isSelected
                                      ? AppColor.backgroundColor
                                          .withOpacity(0.5)
                                      : AppColor.white,
                                  leading: Container(
                                    width: 100.w,
                                    height: 300.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              state.categoryProducts[index]
                                                  .imageUrl),
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedProducts.remove(product);
                                      } else {
                                        selectedProducts.add(product);
                                      }
                                    });
                                  },
                                  splashColor:
                                      AppColor.backgroundColor.withOpacity(0.2),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Container();
                  },
                );
              },
            ),
          )),
      bottomNavigationBar: selectedProducts.isNotEmpty
          ? BottomAppBar(
              height: 60.h,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      AppColor.backgroundColor,
                    ),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )),
                    fixedSize: const MaterialStatePropertyAll(
                      Size.fromWidth(200),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context).translate('submit')),
                  onPressed: () {
                    addBloc.add(
                      AddToSelectedProductsEvent(
                        productIds: selectedProducts.map((e) => e.id).toList(),
                      ),
                    );
                  },
                ),
              ),
            )
          : Container(
              height: 0.0,
            ),
    );
  }
}
