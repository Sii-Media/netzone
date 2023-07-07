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
import '../../core/constant/colors.dart';
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
  List<CategoryProducts> selectedProducts = [];
  @override
  void initState() {
    producBloc.add(GetAllProductsEvent());
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
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
            child: BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
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
                        final isSelected = selectedProducts.contains(product);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                              subtitle: Text(
                                state.categoryProducts[index].description,
                                style: const TextStyle(
                                  color: AppColor.secondGrey,
                                ),
                              ),
                              tileColor: isSelected
                                  ? AppColor.backgroundColor.withOpacity(0.5)
                                  : AppColor.white,
                              leading: Container(
                                width: 100.w,
                                height: 300.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(state
                                          .categoryProducts[index].imageUrl),
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
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (state.categoryProducts[index].owner
                                                .userType ==
                                            'user') {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return UsersProfileScreen(
                                                user: state
                                                    .categoryProducts[index]
                                                    .owner);
                                          }));
                                        } else if (state.categoryProducts[index]
                                                .owner.userType ==
                                            'local_company') {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return LocalCompanyProfileScreen(
                                                localCompany: state
                                                    .categoryProducts[index]
                                                    .owner);
                                          }));
                                        }
                                      },
                                      child: Text(
                                        state.categoryProducts[index].owner
                                                .username ??
                                            '',
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: AppColor.colorOne),
                                      ),
                                    ),
                                    Text(
                                      '${state.categoryProducts[index].price.toString()} \$',
                                      style: const TextStyle(
                                        color: AppColor.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
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
