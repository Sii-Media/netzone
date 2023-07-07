import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';

import '../../../injection_container.dart';
import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';
import '../blocs/get_user/get_user_bloc.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen>
    with ScreenLoader<MyProductsScreen> {
  final productBloc = sl<GetUserBloc>();

  @override
  void initState() {
    productBloc.add(GetSelectedProductsEvent());
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('my_products'),
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
      body: BlocConsumer<GetUserBloc, GetUserState>(
        bloc: productBloc,
        listener: (context, deletestate) {
          if (deletestate is DeleteFromSelectedProductsInProgress) {
            startLoading();
          } else if (deletestate is DeleteFromSelectedProductsFailure) {
            stopLoading();

            final failure = deletestate.message;
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
          } else if (deletestate is DeleteFromSelectedProductsSuccess) {
            stopLoading();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context).translate('success'),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ));
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is GetSelectedProductsInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (state is GetSelectedProductsFailure) {
            final failure = state.message;
            return Center(
              child: Text(
                failure,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else if (state is GetSelectedProductsSuccess) {
            return state.products.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      productBloc.add(GetSelectedProductsEvent());
                    },
                    color: AppColor.white,
                    backgroundColor: AppColor.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: state.products.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ProductDetailScreen(
                                    item: state.products[index].id);
                              }));
                            },
                            child: Card(
                              shadowColor: AppColor.secondGrey,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                // padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  // color: AppColor.secondGrey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100.h,
                                      width: 100.w,
                                      margin: const EdgeInsets.only(
                                        right: 3.0,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            state.products[index].imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.products[index].name,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.backgroundColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120.w,
                                            child: Text(
                                              state.products[index].description,
                                              style: TextStyle(
                                                  color: AppColor.mainGrey,
                                                  fontSize: 12.sp),
                                            ),
                                          ),
                                          Text(
                                            '\$ ${state.products[index].price} ',
                                            style: TextStyle(
                                              color: AppColor.colorThree,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          productBloc.add(
                                              DeleteFromSelectedProductsEvent(
                                                  productId: state
                                                      .products[index].id));
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: AppColor.red,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      AppLocalizations.of(context).translate('no_items'),
                      style: TextStyle(
                        color: AppColor.backgroundColor,
                        fontSize: 25.sp,
                      ),
                    ),
                  );
          }
          return Container();
        },
      ),
    );
  }
}
