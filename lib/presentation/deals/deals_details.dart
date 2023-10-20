import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/calculate_fee.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';

import '../../injection_container.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../utils/remaining_date.dart';
import 'blocs/dealsItems/deals_items_bloc.dart';
import 'edit_deal_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';

class DealDetails extends StatefulWidget {
  const DealDetails({super.key, required this.dealsInfoId});

  final String dealsInfoId;

  @override
  State<DealDetails> createState() => _DealDetailsState();
}

class _DealDetailsState extends State<DealDetails> {
  String secretKey = dotenv.get('STRIPE_SEC_KEY', fallback: '');

  Map<String, dynamic>? paymentIntent;
  late String email;
  late String name;
  final dealBloc = sl<DealsItemsBloc>();
  final authBloc = sl<AuthBloc>();

  @override
  void initState() {
    dealBloc.add(GetDealByIdEvent(id: widget.dealsInfoId));
    authBloc.add(AuthCheckRequested());
    super.initState();
  }

  Future<void> makePayment(
      {required String amount,
      required String currency,
      required String email,
      required String name}) async {
    try {
      // final customerId = await createcustomer(email: email, name: name);
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
            // customerId: customerId['id'],
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
        Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: BackgroundWidget(
          isHome: false,
          widget: BlocBuilder<DealsItemsBloc, DealsItemsState>(
            bloc: dealBloc,
            builder: (context, state) {
              if (state is DealsItemsInProgress) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  ),
                );
              } else if (state is DealsItemsFailure) {
                final failure = state.message;
                return FailureWidget(
                  failure: failure,
                  onPressed: () {
                    dealBloc.add(GetDealByIdEvent(id: widget.dealsInfoId));
                  },
                );
              } else if (state is GetDealByIdSuccess) {
                return RefreshIndicator(
                  onRefresh: () async {
                    dealBloc.add(GetDealByIdEvent(id: widget.dealsInfoId));
                  },
                  color: AppColor.white,
                  backgroundColor: AppColor.backgroundColor,
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        height: size.height * 0.30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: CachedNetworkImage(
                            imageUrl: state.deal.imgUrl,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 70.0, vertical: 50),
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                color: AppColor.backgroundColor,

                                // strokeWidth: 10,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, authState) {
                          if (authState is Authenticated) {
                            email = authState.user.userInfo.email ?? '';
                            name = authState.user.userInfo.username ?? '';
                            if (authState.user.userInfo.id ==
                                state.deal.owner.id) {
                              return Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return EditDealScreen(
                                          deal: state.deal,
                                        );
                                      }));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: AppColor.backgroundColor,
                                      size: 15.sp,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      dealBloc.add(DeleteDealEvent(
                                          id: state.deal.id ?? ''));
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColor.red,
                                      size: 15.sp,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                      titleAndInput(
                        title:
                            "${AppLocalizations.of(context).translate('اسم الصفقة')} : ",
                        input: state.deal.name,
                      ),
                      titleAndInput(
                        title:
                            "${AppLocalizations.of(context).translate('اسم البائع')} : ",
                        input: state.deal.companyName,
                      ),
                      titleAndInput(
                        title:
                            "${AppLocalizations.of(context).translate('تاريخ بدء الصفقة')} : ",
                        input: convertDateToString(state.deal.startDate),
                      ),
                      titleAndInput(
                        title:
                            "${AppLocalizations.of(context).translate('تاريخ انتهاء الصفقة')}: ",
                        input: convertDateToString(state.deal.endDate),
                      ),
                      titleAndInput(
                        title:
                            "${AppLocalizations.of(context).translate('السعر قبل')}:",
                        input: state.deal.prevPrice.toString(),
                      ),
                      titleAndInput(
                        title:
                            "${AppLocalizations.of(context).translate('السعر بعد')} : ",
                        input: state.deal.currentPrice.toString(),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.h),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () {
                              calculateRemainingDays(state.deal.endDate) >= 0
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            AppLocalizations.of(context)
                                                .translate('service_fee'),
                                            style: const TextStyle(
                                                color: AppColor.backgroundColor,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          content: Text(
                                            '${AppLocalizations.of(context).translate('you_should_pay')} ${calculateDealsFee(price: state.deal.currentPrice)} ${AppLocalizations.of(context).translate('AED')}',
                                            style: const TextStyle(
                                              color: AppColor.backgroundColor,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('cancel'),
                                                style: const TextStyle(
                                                    color: AppColor.red),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                double serviceFee =
                                                    calculateDealsFee(
                                                        price: state
                                                            .deal.currentPrice);
                                                double total = serviceFee +
                                                    state.deal.currentPrice;
                                                String amount =
                                                    (total.toInt() * 100)
                                                        .toString();
                                                makePayment(
                                                  amount: amount,
                                                  currency: 'aed',
                                                  email: email,
                                                  name: name,
                                                );
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('submit'),
                                                style: const TextStyle(
                                                    color: AppColor
                                                        .backgroundColor),
                                              ),
                                            ),
                                          ],
                                        );
                                      })
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Sorry, You can not buy this deal',
                                            style: TextStyle(
                                                color:
                                                    AppColor.backgroundColor),
                                          ),
                                          content: const Text(
                                            'Someone else bought the deal',
                                            style: TextStyle(
                                                color: AppColor.secondGrey),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('ok'),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.backgroundColor,
                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                textStyle: TextStyle(fontSize: 15.sp)),
                            child: Text(AppLocalizations.of(context)
                                .translate('اشتري الان'))),
                      ),
                      SizedBox(
                        height: 100.h,
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

Padding titleAndInput({required String title, required String input}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      // height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: AppColor.backgroundColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 190.w,
              child: Text(
                input,
                style: TextStyle(
                  color: AppColor.mainGrey,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

myspec(context, String feature, String details, Color colorbackground,
    Color colortext) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(
      bottom: 5,
      top: 5,
      right: 10,
      left: 10,
    ),
    child: RichText(
      text: TextSpan(
          style: TextStyle(fontSize: 17.sp, color: colorbackground),
          children: <TextSpan>[
            TextSpan(text: feature),
            TextSpan(
              text: details,
              style: TextStyle(color: colortext, fontSize: 13.sp),
            )
          ]),
    ),
  );
}
