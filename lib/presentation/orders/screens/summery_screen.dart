import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/domain/aramex/entities/actual_weight.dart';
import 'package:netzoon/domain/aramex/entities/client_info.dart';
import 'package:netzoon/domain/aramex/entities/contact.dart';
import 'package:netzoon/domain/aramex/entities/create_pickup_input_data.dart';
import 'package:netzoon/domain/aramex/entities/create_shipment_input_data.dart';
import 'package:netzoon/domain/aramex/entities/details.dart';
import 'package:netzoon/domain/aramex/entities/label_info.dart';
import 'package:netzoon/domain/aramex/entities/party_address.dart';
import 'package:netzoon/domain/aramex/entities/pickup.dart';
import 'package:netzoon/domain/aramex/entities/pickup_items.dart';
import 'package:netzoon/domain/aramex/entities/shiper_consignee.dart';
import 'package:netzoon/domain/aramex/entities/shipment.dart';
import 'package:netzoon/domain/aramex/entities/shipment_dimensions.dart';
import 'package:netzoon/domain/aramex/entities/shipment_items.dart';
import 'package:netzoon/domain/aramex/entities/total_amount.dart';
import 'package:netzoon/domain/aramex/entities/transaction.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/domain/order/entities/order_input.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/aramex/blocs/aramex_bloc/aramex_bloc.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/send_email/send_email_bloc.dart';
import 'package:netzoon/presentation/core/blocs/country_bloc/country_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/get_currency_of_country.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/orders/blocs/bloc/my_order_bloc.dart';
import 'package:netzoon/presentation/orders/screens/congs_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';

class SummeryOrderScreen extends StatefulWidget {
  final double totalAmount;
  final double serviceFee;
  final double deliveryFee;
  final String toName;
  final String toEmail;
  final String phoneNumber;
  final String userMobile;
  final String city;
  final double subTotal;
  final String addressDetails;
  final String floorNum;
  final String subject;
  final String from;
  final String productsNames;
  final String grandTotal;
  final List<CategoryProducts> products;
  final double totalWeight;
  final num totalQuantity;
  const SummeryOrderScreen(
      {super.key,
      required this.totalAmount,
      required this.serviceFee,
      required this.deliveryFee,
      required this.toName,
      required this.toEmail,
      required this.userMobile,
      required this.phoneNumber,
      required this.city,
      required this.subTotal,
      required this.addressDetails,
      required this.floorNum,
      required this.subject,
      required this.from,
      required this.productsNames,
      required this.grandTotal,
      required this.products,
      required this.totalWeight,
      required this.totalQuantity});

  @override
  State<SummeryOrderScreen> createState() => _SummeryOrderScreenState();
}

class _SummeryOrderScreenState extends State<SummeryOrderScreen>
    with ScreenLoader<SummeryOrderScreen> {
  final sendBloc = sl<SendEmailBloc>();
  final orderBloc = sl<OrderBloc>();
  final aramexBloc = sl<AramexBloc>();
  final aramexBloc2 = sl<AramexBloc>();
  late final CountryBloc countryBloc;
  late final String orderId;
  late final String pickupId;
  late final CartBlocBloc cartBloc;

  String secretKey = dotenv.get('STRIPE_LIVE_SEC_KEY', fallback: '');

  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment({
    required String amount,
    required String currency,
    required String toName,
    required String toEmail,
    required String userMobile,
    required String city,
    required double subTotal,
    required String addressDetails,
    required String floorNum,
    required String subject,
    required String from,
    required String productsNames,
    required String grandTotal,
    required String serviceFee,
  }) async {
    try {
      // final customerId = await createcustomer(email: toEmail, name: toName);
      paymentIntent = await createPaymentIntent(amount, currency);

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "AE",
        currencyCode: "aed",
        testEnv: false,
      );
      print('jasdjajsdajdsjasd');
      print(paymentIntent);
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
              googlePay: gpay,
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
        serviceFee: serviceFee,
        city: city,
        addressDetails: addressDetails,
        floorNum: floorNum,
        from: from,
        subTotal: subTotal,
        subject: subject,
      );
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet({
    required String toName,
    required String toEmail,
    required String userMobile,
    required String city,
    required double subTotal,
    required String addressDetails,
    required String floorNum,
    required String subject,
    required String from,
    required String productsNames,
    required String grandTotal,
    required String serviceFee,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
        cartBloc.add(ClearCart());

        // double g = widget.totalAmount;
        // double s = widget.serviceFee;

        sendBloc.add(SendEmailPaymentAndDeliveryEvent(
            toName: toName,
            toEmail: toEmail,
            mobile: userMobile,
            city: city,
            productsNames: productsNames,
            grandTotal: grandTotal,
            serviceFee: serviceFee,
            subTotal: subTotal,
            addressDetails: addressDetails,
            floorNum: floorNum,
            subject: subject,
            from: from));

        // sendBloc.add(SendEmailPaymentRequestEvent(
        //   toName: authState.user.userInfo.username ?? '',
        //   toEmail: authState.user.userInfo.email ?? '',
        //   userMobile: authState.user.userInfo.firstMobile ?? '',
        //   productsNames: products.map((e) => e.name).toList().join(' - '),
        //   grandTotal: totalAmount.toString(),
        //   serviceFee: serviceFee.toString(),
        //   subTotal: g - s,
        // ));

        // sendBloc.add(SendEmailDeliveryRequestEvent(
        //   toName: nameController.text,
        //   toEmail: emailController.text,
        //   mobile: phoneNumberController.text,
        //   city: cityController.text,
        //   addressDetails: addressDetailsController.text,
        //   floorNum: floorNumController.text,
        //   subject: 'Order Delivery',
        //   from: widget.from,
        // ));
        // double g = double.parse(grandTotal);
        // double s = double.parse(serviceFee);

        // sendBloc.add(SendEmailPaymentRequestEvent(
        //   toName: toName,
        //   toEmail: toEmail,
        //   userMobile: userMobile,
        //   productsNames: productsNames,
        //   grandTotal: grandTotal,
        //   serviceFee: serviceFee,
        //   subTotal: g - s,
        // ));
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
  void initState() {
    super.initState();
    cartBloc = BlocProvider.of<CartBlocBloc>(context);
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppColor.white,
            size: 22.sp,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).translate('summrey_order'),
        ),
        // leading: const SizedBox(),
        // leadingWidth: 0,
        centerTitle: true,
        backgroundColor: AppColor.backgroundColor,
      ),
      body: BlocListener<SendEmailBloc, SendEmailState>(
        bloc: sendBloc,
        listener: (context, sendState) {
          if (sendState is SendEmailPaymentAndDeliveryInProgress) {
            startLoading();
          } else if (sendState is SendEmailPaymentAndDeliveryFailure) {
            stopLoading();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'failure',
                  style: TextStyle(
                    color: AppColor.white,
                  ),
                ),
                backgroundColor: AppColor.red,
              ),
            );
          } else if (sendState is SendEmailPaymentAndDeliverySuccess) {
            stopLoading();

            // double totalWeight = 0.0;
            // for (CategoryProducts product in widget.products) {
            //   totalWeight += product.weight ?? 0;
            // }
            // print('22222222222222222222222222222222222222222');
            // DateTime pickUpDate = DateTime.now();
            // DateTime readyTime = DateTime.now();
            // DateTime lastPickupTime = pickUpDate.add(const Duration(days: 3));

            // aramexBloc.add(
            //   CreatePickUpEvent(
            //     createPickUpInputData: CreatePickUpInputData(
            //       clientInfo: const ClientInfo(
            //           source: 24,
            //           accountCountryCode: 'AE',
            //           accountEntity: 'DXB',
            //           accountPin: '906169',
            //           accountNumber: '71923340',
            //           userName: 'netzoon.2023@gmail.com',
            //           password: 'Netzoon@123@aramex',
            //           version: 'v1'),
            //       labelInfo: const LabelInfo(
            //         reportID: 9201,
            //         reportType: 'URL',
            //       ),
            //       pickUp: PickUp(
            //         pickupAddress: PartyAddress(
            //           line1: widget.products[0].owner.address ?? "Dubai",
            //           line2: widget.products[0].owner.addressDetails ?? "Dubai",
            //           line3: "",
            //           city: widget.products[0].owner.city ?? "Dubai",
            //           stateOrProvinceCode:
            //               widget.products[0].owner.city ?? "Dubai",
            //           postCode: '',
            //           countryCode: 'AE',
            //           longitude: 0,
            //           latitude: 0,
            //         ),
            //         pickupContact: Contact(
            //           department: 'Test Department',
            //           personName: widget.products[0].owner.contactName ?? "",
            //           title: widget.products[0].owner.username ?? "",
            //           companyName: widget.products[0].owner.username ?? "",
            //           phoneNumber1: widget.products[0].owner.firstMobile ?? "",
            //           cellPhone: widget.products[0].owner.secondeMobile ??
            //               widget.products[0].owner.firstMobile ??
            //               '',
            //           emailAddress: widget.products[0].owner.email ?? '',
            //         ),
            //         pickupLocation: widget.products[0].owner.address ?? '',
            //         pickupDate: "/Date(${pickUpDate.millisecondsSinceEpoch})/",
            //         readyTime: "/Date(${readyTime.millisecondsSinceEpoch})/",
            //         lastPickupTime:
            //             "/Date(${lastPickupTime.millisecondsSinceEpoch})/",
            //         closingTime: "/Date(${pickUpDate.millisecondsSinceEpoch})/",
            //         comments: '',
            //         reference1: '001',
            //         vehicle: 'Car',
            //         pickupItems: [
            //           PickupItems(
            //               productGroup: 'DOM',
            //               productType: 'CDS',
            //               numberOfShipments: 1,
            //               packageTypel: 'Box',
            //               payment: 'P',
            //               shipmentWeight: ActualWeight(
            //                   unit: 'KG', value: widget.totalWeight),
            //               numberOfPieces:
            //                   int.parse(widget.totalQuantity.toString()),
            //               shipmentDimensions: const ShipmentDimensions(
            //                   length: 0, width: 0, height: 0, unit: ''),
            //               comments: 'comments')
            //         ],
            //         status: 'Ready',
            //         branch: '',
            //         routeCode: '',
            //       ),
            //       transaction: const Transaction(
            //         reference1: 'reference1',
            //         reference2: '',
            //         reference3: '',
            //         reference4: '',
            //       ),
            //     ),
            //   ),
            // );
            orderBloc.add(SaveOrderEvent(
                clientId: widget.products[0].owner.id,
                products: widget.products
                    .map((e) => OrderInput(
                        product: e.id,
                        amount: e.price.toDouble(),
                        qty: e.cartQty?.toInt() ?? 1))
                    .toList(),
                orderStatus: 'pending',
                grandTotal: widget.totalAmount + widget.deliveryFee,
                mobile: widget.userMobile,
                serviceFee: widget.serviceFee,
                subTotal: widget.subTotal,
                shippingAddress:
                    '${widget.city} - ${widget.addressDetails} - ${widget.floorNum}'));
          }
        },
        child: BlocListener<OrderBloc, OrderState>(
          bloc: orderBloc,
          listener: (context, orderState) {
            if (orderState is SaveOrderInProgress) {
              startLoading();
            } else if (orderState is SaveOrderFailure) {
              stopLoading();

              final message = orderState.message;
              final failure = orderState.failure;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    message,
                    style: const TextStyle(
                      color: AppColor.white,
                    ),
                  ),
                  backgroundColor: AppColor.red,
                ),
              );
              if (failure is UnAuthorizedFailure) {
                while (context.canPop()) {
                  context.pop();
                }
                context.push('/home');
              }
            } else if (orderState is SaveOrderSuccess) {
              orderId = orderState.order;
              stopLoading();
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text(
              //     AppLocalizations.of(context).translate('success'),
              //   ),
              //   backgroundColor: Theme.of(context).colorScheme.secondary,
              // ));
              double totalWeight = 0.0;
              for (CategoryProducts product in widget.products) {
                totalWeight += product.weight ?? 0;
              }
              print('22222222222222222222222222222222222222222');
              DateTime pickUpDate = DateTime.now();
              DateTime readyTime = DateTime.now();
              DateTime lastPickupTime = pickUpDate.add(const Duration(days: 3));

              aramexBloc.add(
                CreatePickUpEvent(
                  createPickUpInputData: CreatePickUpInputData(
                    clientInfo: const ClientInfo(
                        source: 24,
                        accountCountryCode: 'AE',
                        accountEntity: 'DXB',
                        accountPin: '906169',
                        accountNumber: '71923340',
                        userName: 'netzoon.2023@gmail.com',
                        password: 'Netzoon@123@aramex',
                        version: 'v1'),
                    labelInfo: const LabelInfo(
                      reportID: 9201,
                      reportType: 'URL',
                    ),
                    pickUp: PickUp(
                      pickupAddress: PartyAddress(
                        line1: widget.products[0].owner.address ?? "Dubai",
                        line2:
                            widget.products[0].owner.addressDetails ?? "Dubai",
                        line3: "",
                        city: widget.products[0].owner.city ?? "Dubai",
                        stateOrProvinceCode:
                            widget.products[0].owner.city ?? "Dubai",
                        postCode: '',
                        countryCode: 'AE',
                        longitude: 0,
                        latitude: 0,
                      ),
                      pickupContact: Contact(
                        department: 'Test Department',
                        personName: widget.products[0].owner.contactName ?? "",
                        title: widget.products[0].owner.username ?? "",
                        companyName: widget.products[0].owner.username ?? "",
                        phoneNumber1:
                            widget.products[0].owner.firstMobile ?? "",
                        cellPhone: widget.products[0].owner.secondeMobile ??
                            widget.products[0].owner.firstMobile ??
                            '',
                        emailAddress: widget.products[0].owner.email ?? '',
                      ),
                      pickupLocation: widget.products[0].owner.address ?? '',
                      pickupDate:
                          "/Date(${pickUpDate.millisecondsSinceEpoch})/",
                      readyTime: "/Date(${readyTime.millisecondsSinceEpoch})/",
                      lastPickupTime:
                          "/Date(${lastPickupTime.millisecondsSinceEpoch})/",
                      closingTime:
                          "/Date(${pickUpDate.millisecondsSinceEpoch})/",
                      comments: '',
                      reference1: '001',
                      vehicle: 'Car',
                      pickupItems: [
                        PickupItems(
                            productGroup: 'DOM',
                            productType: 'ONP',
                            numberOfShipments: 1,
                            packageTypel: 'Box',
                            payment: 'P',
                            shipmentWeight: ActualWeight(
                                unit: 'KG', value: widget.totalWeight),
                            numberOfPieces:
                                int.parse(widget.totalQuantity.toString()),
                            shipmentDimensions: const ShipmentDimensions(
                                length: 0, width: 0, height: 0, unit: ''),
                            comments: 'comments')
                      ],
                      status: 'Ready',
                      branch: '',
                      routeCode: '',
                    ),
                    transaction: const Transaction(
                      reference1: 'reference1',
                      reference2: '',
                      reference3: '',
                      reference4: '',
                    ),
                  ),
                ),
              );
              // orderBloc.add(SaveOrderEvent(
              //     clientId: widget.products[0].owner.id,
              //     products: widget.products
              //         .map((e) => OrderInput(
              //             product: e.id,
              //             amount: e.price.toDouble(),
              //             qty: e.cartQty?.toInt() ?? 1))
              //         .toList(),
              //     orderStatus: 'pending',
              //     grandTotal: widget.totalAmount + widget.deliveryFee,
              //     mobile: widget.userMobile,
              //     serviceFee: widget.serviceFee,
              //     subTotal: widget.subTotal,
              //     shippingAddress:
              //         '${widget.city} - ${widget.addressDetails} - ${widget.floorNum}'));
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //   return const CongsScreen();
              // }));
            }
          },
          child: BlocListener<AramexBloc, AramexState>(
            bloc: aramexBloc,
            listener: (context, pickupState) {
              if (pickupState is CreatePickUpInProgress) {
                startLoading();
              } else if (pickupState is CreatePickUpInFailue) {
                stopLoading();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'failure',
                      style: TextStyle(
                        color: AppColor.white,
                      ),
                    ),
                    backgroundColor: AppColor.red,
                  ),
                );
              } else if (pickupState is CreatePickUpSuccess) {
                stopLoading();
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text(
                //     AppLocalizations.of(context).translate('success'),
                //   ),
                //   backgroundColor: Theme.of(context).colorScheme.secondary,
                // ));
                pickupId = pickupState.createPickUpResponse.processedPickup.id;
                double totalWeight = 0.0;
                for (CategoryProducts product in widget.products) {
                  totalWeight += product.weight ?? 0;
                }

                DateTime shippingDateTime = DateTime.now();

                DateTime dueDate =
                    shippingDateTime.add(const Duration(days: 3));
                orderBloc.add(
                    UpdateOrderPickupEvent(id: orderId, pickupId: pickupId));
                aramexBloc2.add(CreateShipmentEvent(
                    createShipmentInputData: CreateShipmentInputData(
                        shipments: [
                      Shipments(
                          reference1: '',
                          reference2: '',
                          reference3: '',
                          shipper: ShipperOrConsignee(
                            reference1: '',
                            accountNumber: '71923340',
                            partyAddress: PartyAddress(
                                line1: widget.products[0].owner.address ?? '',
                                line2:
                                    widget.products[0].owner.addressDetails ??
                                        '',
                                city: widget.products[0].owner.city ?? 'Dubai',
                                stateOrProvinceCode:
                                    widget.products[0].owner.city ?? 'Dubai',
                                countryCode: 'AE',
                                longitude: 0,
                                latitude: 0),
                            contact: Contact(
                              department: widget.products[0].owner.address,
                              personName:
                                  widget.products[0].owner.contactName ?? '',
                              title: 'title',
                              companyName:
                                  widget.products[0].owner.username ?? '',
                              phoneNumber1:
                                  widget.products[0].owner.firstMobile ?? '',
                              cellPhone:
                                  widget.products[0].owner.firstMobile ?? '',
                              emailAddress:
                                  widget.products[0].owner.email ?? '',
                            ),
                          ),
                          consignee: ShipperOrConsignee(
                              reference1: '',
                              accountNumber: '71923340',
                              partyAddress: PartyAddress(
                                  line1: widget.addressDetails,
                                  city: widget.city,
                                  stateOrProvinceCode: widget.city,
                                  postCode: "",
                                  countryCode: 'AE',
                                  longitude: 0,
                                  latitude: 0),
                              contact: Contact(
                                  department: widget.addressDetails,
                                  personName: widget.toName,
                                  title: 'title',
                                  companyName: widget.toName,
                                  phoneNumber1: widget.userMobile,
                                  cellPhone: widget.phoneNumber,
                                  emailAddress: widget.toEmail)),
                          thirdParty: null,
                          shippingDateTime:
                              "/Date(${shippingDateTime.millisecondsSinceEpoch})/",
                          dueDate: "/Date(${dueDate.millisecondsSinceEpoch})/",
                          comments: 'comments',
                          details: ShipmentDetails(
                            actualWeight: ActualWeight(
                                unit: 'KG', value: widget.totalWeight),
                            descriptionOfGoods: 'items',
                            goodsOriginCountry: 'AE',
                            numberOfPieces:
                                int.parse(widget.totalQuantity.toString()),
                            productGroup: 'DOM',
                            productType: 'ONP',
                            paymentType: 'P',
                            items: widget.products.map((e) {
                              return ShipmentItems(
                                  packageType: 'item',
                                  quantity: e.cartQty != null
                                      ? e.cartQty!.toInt()
                                      : 1,
                                  weight: ActualWeight(
                                      unit: 'KG', value: e.weight ?? 0),
                                  comments: 'comments',
                                  reference: '',
                                  commodityCode: 640000,
                                  goodsDescription: 'goodsDescription',
                                  countryOfOrigin: 'AE',
                                  customsValue: const TotalAmount(
                                      currencyCode: 'AED', value: 0));
                            }).toList(),
                          ),
                          transportType: 0,
                          pickupGUID: pickupState
                              .createPickUpResponse.processedPickup.guid),
                    ],
                        labelInfo:
                            const LabelInfo(reportID: 9729, reportType: 'URL'),
                        clientInfo: const ClientInfo(
                            source: 24,
                            accountCountryCode: 'AE',
                            accountEntity: 'DXB',
                            accountPin: '906169',
                            accountNumber: '71923340',
                            userName: 'netzoon.2023@gmail.com',
                            password: 'Netzoon@123@aramex',
                            version: 'v1'),
                        transaction:
                            const Transaction(reference1: 'reference1'))));
              }
            },
            child: BlocListener<AramexBloc, AramexState>(
              bloc: aramexBloc2,
              listener: (context, shipmentState) {
                if (shipmentState is CreateShipmentInProgress) {
                  startLoading();
                } else if (shipmentState is CreateShipmentInFailue) {
                  stopLoading();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'failure',
                        style: TextStyle(
                          color: AppColor.white,
                        ),
                      ),
                      backgroundColor: AppColor.red,
                    ),
                  );
                } else if (shipmentState is CreateShipmentSuccess) {
                  stopLoading();
                  if (shipmentState.createShipmentResponse.hasError == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'failure',
                          style: TextStyle(
                            color: AppColor.white,
                          ),
                        ),
                        backgroundColor: AppColor.red,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        AppLocalizations.of(context).translate('success'),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ));
                    print('asdasddddddddddddddddddddddddddddddd');
                    // orderBloc.add(SaveOrderEvent(
                    //     clientId: widget.products[0].owner.id,
                    //     products: widget.products
                    //         .map((e) => OrderInput(
                    //             product: e.id,
                    //             amount: e.price.toDouble(),
                    //             qty: e.cartQty?.toInt() ?? 1))
                    //         .toList(),
                    //     orderStatus: 'pending',
                    //     grandTotal: widget.totalAmount + widget.deliveryFee,
                    //     mobile: widget.userMobile,
                    //     serviceFee: widget.serviceFee,
                    //     subTotal: widget.subTotal,
                    //     shippingAddress:
                    //         '${widget.city} - ${widget.addressDetails} - ${widget.floorNum}'));
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const CongsScreen();
                    }));
                  }
                }
              },
              child: BlocBuilder<CountryBloc, CountryState>(
                bloc: countryBloc,
                builder: (context, countryState) {
                  if (countryState is CountryInitial) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('order_total'),
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: AppColor.backgroundColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: widget.totalAmount.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: getCurrencyFromCountry(
                                            countryState.selectedCountry,
                                            context),
                                        style: TextStyle(
                                            color: AppColor.backgroundColor,
                                            fontSize: 10.sp),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('service_fee'),
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: AppColor.backgroundColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: widget.serviceFee.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: getCurrencyFromCountry(
                                            countryState.selectedCountry,
                                            context),
                                        style: TextStyle(
                                            color: AppColor.backgroundColor,
                                            fontSize: 10.sp),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('delivery_fee'),
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: AppColor.backgroundColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: widget.deliveryFee.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: getCurrencyFromCountry(
                                            countryState.selectedCountry,
                                            context),
                                        style: TextStyle(
                                            color: AppColor.backgroundColor,
                                            fontSize: 10.sp),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('total_amount'),
                                style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${widget.totalAmount + widget.deliveryFee + widget.serviceFee}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: getCurrencyFromCountry(
                                            countryState.selectedCountry,
                                            context),
                                        style: TextStyle(
                                            color: AppColor.primaryColor,
                                            fontSize: 10.sp),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                          const Divider(),
                          SizedBox(
                            height: 10.h,
                          ),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: InkWell(
                                onTap: () {
                                  double tm = widget.totalAmount +
                                      widget.deliveryFee +
                                      widget.serviceFee;
                                  String amount = (tm.toInt() * 100).toString();
                                  makePayment(
                                    amount: amount,
                                    currency: getCurrencyFromCountryStripe(
                                        countryState.selectedCountry, context),
                                    toName: widget.toName,
                                    userMobile: widget.userMobile,
                                    addressDetails: widget.addressDetails,
                                    city: widget.city,
                                    floorNum: widget.floorNum,
                                    from: widget.from,
                                    grandTotal: widget.grandTotal,
                                    productsNames: widget.productsNames,
                                    serviceFee: widget.serviceFee.toString(),
                                    subTotal: widget.subTotal,
                                    subject: widget.subject,
                                    toEmail: widget.toEmail,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 40.h,
                                  width: 200.w,
                                  color: AppColor.backgroundColor,
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('check_out'),
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: AppColor.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
