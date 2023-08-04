import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/cart/cart_item_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../injection_container.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../auth/screens/signin.dart';
import '../core/helpers/calculate_fee.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final authBloc = sl<AuthBloc>();

  @override
  void initState() {
    authBloc.add(AuthCheckRequested());

    super.initState();
  }

  double totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (context, authState) {
          if (authState is AuthInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          }
          if (authState is Authenticated) {
            return BlocBuilder<CartBlocBloc, CartBlocState>(
              builder: (context, state) {
                if (state is CartLoaded) {
                  if (state.props.isEmpty) {
                    // setState(() {
                    //   totalPrice = state.totalPrice;
                    // });
                    return Center(
                      child: Text(
                        AppLocalizations.of(context).translate('empty_cart'),
                        style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 22.sp,
                        ),
                      ),
                    );
                  }
                  return Container(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    // height: 700.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      // color: AppColor.secondGrey.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0),
                      ),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.props.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return CartItemWidget(
                          cart: state.props[index],
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).translate('You must log in first'),
                style: TextStyle(
                  color: AppColor.mainGrey,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      AppColor.backgroundColor,
                    ),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )),
                  ),
                  child: Text(AppLocalizations.of(context).translate('login')),
                  onPressed: () async {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const SignInScreen();
                    }));
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: authBloc,
          builder: (context, authState) {
            if (authState is Authenticated) {
              return BlocBuilder<CartBlocBloc, CartBlocState>(
                builder: (context, state) {
                  return BottomAppBar(
                    // elevation: 1,
                    // color: Colors.red,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      height: 200.h,
                      decoration: const BoxDecoration(
                          color: AppColor.backgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('order_total'),
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state is CartLoaded
                                    ? '${state.totalPrice}AED'
                                    : '0AED',
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('service_fee'),
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                state is CartLoaded
                                    ? authState.user.userInfo.userType ==
                                            'local_company'
                                        ? '${calculateTraderFee(items: state.items)}AED'
                                        : '${calculatePurchaseFee(state.totalPrice)}'
                                    : '0',
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: AppColor.mainGrey,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('total_amount'),
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                state is CartLoaded
                                    ? authState.user.userInfo.userType ==
                                                'trader' ||
                                            authState.user.userInfo.userType ==
                                                'local_company'
                                        ? '${state.totalPrice + calculateTraderFee(items: state.items)} AED'
                                        : '${state.totalPrice + calculatePurchaseFee(state.totalPrice)}AED'
                                    : '0AED',
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColor.white)),
                            child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('check_out'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
