import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/cart/cart_item_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/get_currency_of_country.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../injection_container.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../auth/screens/signin.dart';
import '../core/blocs/country_bloc/country_bloc.dart';
import '../core/helpers/calculate_fee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, dynamic>? paymentIntent;

  final authBloc = sl<AuthBloc>();
  late final CountryBloc countryBloc;

  @override
  void initState() {
    authBloc.add(AuthCheckRequested());
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
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
                  return BlocBuilder<CountryBloc, CountryState>(
                    bloc: countryBloc,
                    builder: (context, countryState) {
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
                              currency: getCurrencyFromCountry(
                                  countryState.selectedCountry, context),
                            );
                          },
                        ),
                      );
                    },
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        AppColor.backgroundColor,
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                    ),
                    child:
                        Text(AppLocalizations.of(context).translate('login')),
                    onPressed: () async {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const SignInScreen();
                      }));
                    },
                  ),
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
              return BlocBuilder<CountryBloc, CountryState>(
                bloc: countryBloc,
                builder: (context, countryState) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  // Text(
                                  //   state is CartLoaded
                                  //       ? '${state.totalPrice}AED'
                                  //       : '0AED',
                                  //   style: TextStyle(
                                  //     color: AppColor.white,
                                  //     fontSize: 17.sp,
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // )
                                  RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          color: AppColor.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: state is CartLoaded
                                                ? '${state.totalPrice}'
                                                : '0',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text: getCurrencyFromCountry(
                                              countryState.selectedCountry,
                                              context,
                                            ),
                                            style: TextStyle(
                                                color: AppColor.white,
                                                fontSize: 10.sp),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  // Text(
                                  //   state is CartLoaded
                                  //       ? authState.user.userInfo.userType ==
                                  //               'local_company'
                                  //           ? '${calculateTraderFee(items: state.items)}AED'
                                  //           : '${calculatePurchaseFee(state.totalPrice)}'
                                  //       : '0',
                                  //   style: TextStyle(
                                  //     color: AppColor.white,
                                  //     fontSize: 17.sp,
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // ),
                                  RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          color: AppColor.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: state is CartLoaded
                                                ? authState.user.userInfo
                                                            .userType ==
                                                        'local_company'
                                                    ? '${calculateTraderFee(items: state.items)}'
                                                    : '${calculatePurchaseFee(state.totalPrice)}'
                                                : '0',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text: getCurrencyFromCountry(
                                              countryState.selectedCountry,
                                              context,
                                            ),
                                            style: TextStyle(
                                                color: AppColor.white,
                                                fontSize: 10.sp),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: AppColor.mainGrey,
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  // Text(
                                  //   state is CartLoaded
                                  //       ? authState.user.userInfo.userType ==
                                  //                   'trader' ||
                                  //               authState.user.userInfo
                                  //                       .userType ==
                                  //                   'local_company'
                                  //           ? '${state.totalPrice + calculateTraderFee(items: state.items)} AED'
                                  //           : '${state.totalPrice + calculatePurchaseFee(state.totalPrice)}AED'
                                  //       : '0AED',
                                  //   style: TextStyle(
                                  //     color: AppColor.white,
                                  //     fontSize: 17.sp,
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // ),
                                  RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          color: AppColor.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: state is CartLoaded
                                                ? authState.user.userInfo
                                                                .userType ==
                                                            'trader' ||
                                                        authState.user.userInfo
                                                                .userType ==
                                                            'local_company'
                                                    ? '${state.totalPrice + calculateTraderFee(items: state.items)}'
                                                    : '${state.totalPrice + calculatePurchaseFee(state.totalPrice)}'
                                                : '0',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text: getCurrencyFromCountry(
                                              countryState.selectedCountry,
                                              context,
                                            ),
                                            style: TextStyle(
                                                color: AppColor.white,
                                                fontSize: 10.sp),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  if (state is CartLoaded) {
                                    String amount =
                                        (state.totalPrice.toInt() * 100)
                                            .toString();
                                    makePayment(
                                      amount: amount,
                                      currency: 'AED',
                                    );
                                  } else {
                                    print('asd');
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border:
                                          Border.all(color: AppColor.white)),
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
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Future<void> makePayment(
      {required String amount, required String currency}) async {
    try {
      paymentIntent = await createPaymentIntent(amount, currency);

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "GP",
        currencyCode: "GBP",
        testEnv: true,
      );

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret:
                paymentIntent!['client_secret'], //Gotten from payment intent
            style: ThemeMode.light,
            merchantDisplayName: 'Netzoon',
            // googlePay: gpay,
          ))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51NcotDFDslnmTEHTPCFTKNDMtYwf06E9qZ0Ch3rHa8kI6wbx6LPPTuD0qmN3JG2MF9MtoSr8JjmAfwcxNECDaBvZ00yMpBm3f1',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
