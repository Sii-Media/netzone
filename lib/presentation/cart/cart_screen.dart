import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/cart/cart_item_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/get_currency_of_country.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../injection_container.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../auth/screens/signin.dart';
import '../contact/blocs/send_email/send_email_bloc.dart';
import '../core/blocs/country_bloc/country_bloc.dart';
import '../core/helpers/calculate_fee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../core/widgets/screen_loader.dart';
import '../orders/screens/delivery_details_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with ScreenLoader<CartScreen> {
  String secretKey = dotenv.get('STRIPE_SEC_KEY', fallback: '');

  Map<String, dynamic>? paymentIntent;

  final authBloc = sl<AuthBloc>();
  final sendBloc = sl<SendEmailBloc>();
  late final CountryBloc countryBloc;
  late final CartBlocBloc cartBloc;
  late List<CategoryProducts> products = [];
  @override
  void initState() {
    authBloc.add(AuthCheckRequested());
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    cartBloc = BlocProvider.of<CartBlocBloc>(context);
    super.initState();
  }

  double totalPrice = 0;
  late double totalAmount = 0;
  late double serviceFee = 0;
  late Set<String> from = <String>{};
  Future<void> makePayment({
    required String amount,
    required String currency,
    required String toName,
    required String toEmail,
    required String userMobile,
    required String productsNames,
    required String grandTotal,
    required String serviceFee,
  }) async {
    try {
      // final customerId = await createcustomer(email: toEmail, name: toName);
      paymentIntent = await createPaymentIntent(amount, currency);

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "UAE",
        currencyCode: "aed",
        testEnv: true,
      );
      print(paymentIntent!['client_secret']);
      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret:
                  paymentIntent!['client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'Netzoon',
              // customerId: customerId['id'],
              // googlePay: gpay,
              allowsDelayedPaymentMethods: true,
              // billingDetails: const BillingDetails(
              //   name: 'adams',
              // ),
              // billingDetailsCollectionConfiguration:
              //     const BillingDetailsCollectionConfiguration(
              //   name: CollectionMode.always,
              // ),
            ),
          )
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(
          toName: toName,
          toEmail: toEmail,
          userMobile: userMobile,
          productsNames: productsNames,
          grandTotal: grandTotal,
          serviceFee: serviceFee);
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet({
    required String toName,
    required String toEmail,
    required String userMobile,
    required String productsNames,
    required String grandTotal,
    required String serviceFee,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");

        cartBloc.add(ClearCart());
        double g = double.parse(grandTotal);
        double s = double.parse(serviceFee);

        sendBloc.add(SendEmailPaymentRequestEvent(
          toName: toName,
          toEmail: toEmail,
          userMobile: userMobile,
          productsNames: productsNames,
          grandTotal: grandTotal,
          serviceFee: serviceFee,
          subTotal: g - s,
        ));
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
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future createcustomer({required String email, required String name}) async {
    try {
      Map<String, dynamic> body = {
        'email': email,
        'description': name,
      };

      //final response  = await http.post(Uri.parse("https://api.stripe.com/v1/customers"),
      final response = await http.post(
        Uri.parse("https://api.stripe.com/v1/customers"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer $secretKey",
        },
        body: body,
      );
      print('resvfdg: ${jsonDecode(response.body)}');
      return json.decode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  late UserInfo userInfo;
  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: BlocListener<SendEmailBloc, SendEmailState>(
        bloc: sendBloc,
        listener: (context, emailState) {
          if (emailState is SendEmailInProgress) {
            startLoading();
          } else if (emailState is SendEmailFailure) {
            stopLoading();

            final failure = emailState.message;
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
          } else if (emailState is SendEmailPaymentSuccess) {
            stopLoading();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context).translate('success'),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ));
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return DeliveryDetailsScreen(
                userInfo: userInfo,
                from: from.join(' / '),
                products: products,
                serviceFee: emailState.serviceFee,
                subTotal: emailState.subtotal,
                totalAmount: emailState.grandTotal,
                productsNames: products.map((e) => e.name).toList().join(' - '),
              );
            }));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
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
              userInfo = authState.user.userInfo;
              return BlocBuilder<CartBlocBloc, CartBlocState>(
                builder: (context, state) {
                  if (state is CartLoaded) {
                    if (state.props.isEmpty) {
                      totalPrice = state.totalPrice;
                      totalAmount = state.totalPrice;

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
                    products = state.props;

                    for (var product in products) {
                      from.add(product.owner.username ?? '');
                    }
                    print(from);
                    print(from.join('/'));
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
                  AppLocalizations.of(context)
                      .translate('You must log in first'),
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
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 90.h),
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: authBloc,
          builder: (context, authState) {
            if (authState is Authenticated) {
              return BlocBuilder<CountryBloc, CountryState>(
                bloc: countryBloc,
                builder: (context, countryState) {
                  return BlocBuilder<CartBlocBloc, CartBlocState>(
                    builder: (context, state) {
                      totalAmount = state is CartLoaded
                          ? authState.user.userInfo.userType == 'trader' ||
                                  authState.user.userInfo.userType ==
                                      'local_company'
                              ? state.totalPrice +
                                  calculateTraderFee(items: state.items)
                              : state.totalPrice +
                                  calculatePurchaseFee(state.totalPrice)
                          : 0;
                      serviceFee = state is CartLoaded
                          ? authState.user.userInfo.userType == 'local_company'
                              ? calculateTraderFee(items: state.items)
                              : calculatePurchaseFee(state.totalPrice)
                          : 0;
                      return BottomAppBar(
                        // elevation: 1,
                        // color: Colors.red,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          height: 220.h,
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return DeliveryDetailsScreen(
                                        userInfo: userInfo,
                                        from: from.join(' / '),
                                        products: products,
                                        serviceFee: serviceFee,
                                        subTotal: totalAmount - serviceFee,
                                        totalAmount: totalAmount,
                                        productsNames: products
                                            .map((e) => e.name)
                                            .toList()
                                            .join(' - '),
                                      );
                                    }));
                                    // String amount =
                                    //     (totalAmount.toInt() * 100).toString();
                                    // makePayment(
                                    //   amount: amount,
                                    //   currency: 'AED',
                                    //   toName:
                                    //       authState.user.userInfo.username ??
                                    //           '',
                                    //   toEmail:
                                    //       authState.user.userInfo.email ?? '',
                                    //   userMobile:
                                    //       authState.user.userInfo.firstMobile ??
                                    //           '',
                                    //   productsNames: products
                                    //       .map((e) => e.name)
                                    //       .toList()
                                    //       .join(' - '),
                                    //   grandTotal: totalAmount.toString(),
                                    //   serviceFee: serviceFee.toString(),
                                    // );
                                    // double g = totalAmount;
                                    // double s = serviceFee;

                                    // sendBloc.add(SendEmailPaymentRequestEvent(
                                    //   toName:
                                    //       authState.user.userInfo.username ??
                                    //           '',
                                    //   toEmail:
                                    //       authState.user.userInfo.email ?? '',
                                    //   userMobile:
                                    //       authState.user.userInfo.firstMobile ??
                                    //           '',
                                    //   productsNames: products
                                    //       .map((e) => e.name)
                                    //       .toList()
                                    //       .join(' - '),
                                    //   grandTotal: totalAmount.toString(),
                                    //   serviceFee: serviceFee.toString(),
                                    //   subTotal: g - s,
                                    // ));
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
                                        .translate('confirm'),
                                    style: TextStyle(
                                      fontSize: 16.sp,
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
}
