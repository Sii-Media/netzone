import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/advertising/blocs/add_ads/add_ads_bloc.dart';
import 'package:netzoon/presentation/categories/delivery_company/blocs/delivery_service/delivery_service_bloc.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/categories/real_estate/blocs/real_estate/real_estate_bloc.dart';
import 'package:netzoon/presentation/categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import 'package:netzoon/presentation/core/blocs/fees_bloc/fees_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/calculate_ads_price.dart';
import 'package:netzoon/presentation/core/helpers/pick_date_time.dart';
import 'package:netzoon/presentation/core/helpers/show_submit_ads_pay_dialog.dart';
import 'package:netzoon/presentation/core/widgets/add_photo_button.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/profile/blocs/get_user/get_user_bloc.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';
import 'package:http/http.dart' as http;

import '../utils/app_localizations.dart';

class UserItemsScreen extends StatefulWidget {
  final String category;
  final String? userId;
  const UserItemsScreen({super.key, required this.category, this.userId});

  @override
  State<UserItemsScreen> createState() => _UserItemsScreenState();
}

class _UserItemsScreenState extends State<UserItemsScreen>
    with ScreenLoader<UserItemsScreen> {
  final productBloc = sl<GetUserBloc>();
  final vehicleBloc = sl<VehicleBloc>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController startDateController = TextEditingController();
  late TextEditingController endDateController = TextEditingController();
  late TextEditingController yearController = TextEditingController();
  late TextEditingController locationController = TextEditingController();
  String? _selectedStartDate;
  String? _selectedEndDate;
  Map<String, dynamic>? paymentIntent;
  final addAdsbloc = sl<AddAdsBloc>();
  final realEstatesBloc = sl<RealEstateBloc>();
  final serviceBloc = sl<LocalCompanyBloc>();
  final deliveryBloc = sl<DeliveryServiceBloc>();
  final selectedProductBloc = sl<GetUserBloc>();
  final feesBloc = sl<FeesBloc>();
  double _totalPrice = 0;

  @override
  void initState() {
    triggerBloc();
    feesBloc.add(GetFeesInfoEvent());
    super.initState();
  }

  void triggerBloc() {
    switch (widget.category) {
      case 'product':
        productBloc.add(GetUserProductsEvent());
        break;
      case 'car':
        vehicleBloc
            .add(GetCompanyVehiclesEvent(type: 'car', id: widget.userId ?? ''));
        break;
      case 'planes':
        vehicleBloc.add(
            GetCompanyVehiclesEvent(type: 'planes', id: widget.userId ?? ''));
        break;
      case 'sea_companies':
        vehicleBloc.add(GetCompanyVehiclesEvent(
            type: 'sea_companies', id: widget.userId ?? ''));
        break;
      case 'real_estate':
        realEstatesBloc
            .add(GetCompanyRealEstatesEvent(id: widget.userId ?? ''));
        break;
      case 'service':
        serviceBloc.add(GetCompanyServicesEvent());
        break;
      case 'delivery_service':
        deliveryBloc
            .add(GetDeliveryCompanyServicesEvent(id: widget.userId ?? ''));
        break;
      case 'user':
        selectedProductBloc
            .add(GetSelectedProductsByUserIdEvent(userId: widget.userId ?? ''));
        break;

      default:
        null;
    }
  }

  Future<void> makePayment({
    required String amount,
    required String currency,
    required String title,
    required String description,
    required String location,
    required String imagePath,
    required double price,
    required String itemId,
  }) async {
    try {
      // final customerId = await createcustomer(email: email, name: name);
      paymentIntent = await createPaymentIntent(amount, currency);

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "AE",
        currencyCode: "aed",
        testEnv: false,
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

            googlePay: gpay,
          ))
          .then((value) {});
      final double cost = double.parse(amount) / 100;
      //STEP 3: Display Payment sheet
      displayPaymentSheet(
          title: title,
          description: description,
          location: location,
          imagePath: imagePath,
          price: price,
          itemId: itemId,
          cost: cost);
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet({
    required String title,
    required String description,
    required String location,
    required String imagePath,
    required double price,
    required String itemId,
    required double cost,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
        addAdsbloc.add(AddAdsRequestedEvent(
            advertisingTitle: title,
            advertisingStartDate: _selectedStartDate ?? '',
            advertisingEndDate: _selectedEndDate ?? '',
            advertisingDescription: description,
            advertisingYear: yearController.text,
            advertisingLocation: locationController.text,
            imagePath: imagePath,
            advertisingPrice: price,
            advertisingType: widget.category,
            purchasable: true,
            itemId: itemId,
            forPurchase: true,
            cost: cost));
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
      // String secretKey = dotenv.get('STRIPE_LIVE_SEC_KEY', fallback: '');

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose from profile',
        ),
        backgroundColor: AppColor.backgroundColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          productBloc.add(GetUserProductsEvent());
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(
            8.0,
          ),
          child: BlocListener<AddAdsBloc, AddAdsState>(
            bloc: addAdsbloc,
            listener: (context, addAdsState) async {
              if (addAdsState is AddAdsInProgress) {
                startLoading();
              } else if (addAdsState is AddAdsFailure) {
                stopLoading();

                final message = addAdsState.message;
                final failure = addAdsState.failure;

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
              } else if (addAdsState is AddAdsSuccess) {
                stopLoading();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('success'),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ));
              }
            },
            child: getChild(category: widget.category),
          ),
        ),
      ),
    );
  }

  Widget getChild({required String category}) {
    if (category == 'product') {
      return BlocBuilder<GetUserBloc, GetUserState>(
        bloc: productBloc,
        builder: (context, productState) {
          if (productState is GetUserProductsInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (productState is GetUserProductsFailure) {
            final failure = productState.message;
            return Center(
              child: Text(
                failure,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else if (productState is GetUserProductsSuccess) {
            return productState.products.isEmpty
                ? Center(
                    child: Text(
                        AppLocalizations.of(context).translate('no_items'),
                        style:
                            const TextStyle(color: AppColor.backgroundColor)),
                  )
                : ListView.builder(
                    itemCount: productState.products.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ItemAdsWidget(
                        name: productState.products[index].name,
                        imageUrl: productState.products[index].imageUrl,
                        onTap: () async {
                          bool isWantAdd = await _showAddtoAdsDialog();
                          if (isWantAdd == true) {
                            String amount = (_totalPrice * 100).toString();
                            makePayment(
                                amount: amount,
                                currency: 'aed',
                                title: productState.products[index].name,
                                description:
                                    productState.products[index].description,
                                location:
                                    productState.products[index].address ?? '',
                                imagePath:
                                    productState.products[index].imageUrl,
                                price: productState
                                        .products[index].priceAfterDiscount ??
                                    productState.products[index].price,
                                itemId: productState.products[index].id);
                          }
                        },
                      );
                    },
                  );
          }
          return const SizedBox();
        },
      );
    } else if (category == 'car' ||
        category == 'planes' ||
        category == 'sea_companies') {
      return BlocBuilder<VehicleBloc, VehicleState>(
        bloc: vehicleBloc,
        builder: (context, vehicleState) {
          if (vehicleState is VehicleInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (vehicleState is VehicleFailure) {
            final failure = vehicleState.message;
            return Center(
              child: Text(
                failure,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else if (vehicleState is GetCompanyVehiclesSuccess) {
            return vehicleState.companyVehicles.isEmpty
                ? Center(
                    child: Text(
                        AppLocalizations.of(context).translate('no_items'),
                        style:
                            const TextStyle(color: AppColor.backgroundColor)),
                  )
                : ListView.builder(
                    itemCount: vehicleState.companyVehicles.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ItemAdsWidget(
                        name: vehicleState.companyVehicles[index].name,
                        imageUrl: vehicleState.companyVehicles[index].imageUrl,
                        onTap: () async {
                          bool isWantAdd = await _showAddtoAdsDialog();
                          if (isWantAdd == true) {
                            String amount = (_totalPrice * 100).toString();
                            makePayment(
                                amount: amount,
                                currency: 'aed',
                                title: vehicleState.companyVehicles[index].name,
                                description: vehicleState
                                    .companyVehicles[index].description,
                                location: vehicleState
                                    .companyVehicles[index].location,
                                imagePath: vehicleState
                                    .companyVehicles[index].imageUrl,
                                price: vehicleState.companyVehicles[index].price
                                    .toDouble(),
                                itemId:
                                    vehicleState.companyVehicles[index].id ??
                                        '');
                          }
                        },
                      );
                    },
                  );
          }
          return Container();
        },
      );
    } else if (category == 'real_estate') {
      return BlocBuilder<RealEstateBloc, RealEstateState>(
        bloc: realEstatesBloc,
        builder: (context, realEstateState) {
          if (realEstateState is GetRealEstateInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (realEstateState is GetRealEstateFailure) {
            final failure = realEstateState.message;
            return Center(
              child: Text(
                failure,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else if (realEstateState is GetCompanyRealEstatesSuccess) {
            return realEstateState.realEstates.isEmpty
                ? Center(
                    child: Text(
                        AppLocalizations.of(context).translate('no_items'),
                        style:
                            const TextStyle(color: AppColor.backgroundColor)),
                  )
                : ListView.builder(
                    itemCount: realEstateState.realEstates.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ItemAdsWidget(
                          name: realEstateState.realEstates[index].title,
                          imageUrl:
                              realEstateState.realEstates[index].imageUrl);
                    },
                  );
          }
          return Container();
        },
      );
    } else if (category == 'service') {
      return BlocBuilder<LocalCompanyBloc, LocalCompanyState>(
        bloc: serviceBloc,
        builder: (context, serviceState) {
          if (serviceState is LocalCompanyInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (serviceState is LocalCompanyFailure) {
            final failure = serviceState.message;
            return Center(
              child: Text(
                failure,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else if (serviceState is GetCompanyServiceSuccess) {
            return serviceState.services.isEmpty
                ? Center(
                    child: Text(
                        AppLocalizations.of(context).translate('no_items'),
                        style:
                            const TextStyle(color: AppColor.backgroundColor)),
                  )
                : ListView.builder(
                    itemCount: serviceState.services.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ItemAdsWidget(
                        name: serviceState.services[index].title,
                        imageUrl: serviceState.services[index].imageUrl ?? '',
                        onTap: () async {
                          bool isWantAdd = await _showAddtoAdsDialog();
                          if (isWantAdd == true) {
                            String amount = (_totalPrice * 100).toString();
                            makePayment(
                                amount: amount,
                                currency: 'aed',
                                title: serviceState.services[index].title,
                                description:
                                    serviceState.services[index].description,
                                location: serviceState
                                        .services[index].owner.address ??
                                    '',
                                imagePath:
                                    serviceState.services[index].imageUrl ?? '',
                                price: serviceState.services[index].price
                                        ?.toDouble() ??
                                    0,
                                itemId: serviceState.services[index].id);
                          }
                        },
                      );
                    },
                  );
          }
          return const SizedBox();
        },
      );
    } else if (category == 'delivery_service') {
      return BlocBuilder<DeliveryServiceBloc, DeliveryServiceState>(
        bloc: deliveryBloc,
        builder: (context, deliveryState) {
          if (deliveryState is DeliveryServiceInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (deliveryState is DeliveryServiceFailure) {
            final failure = deliveryState.message;
            return Center(
              child: Text(
                failure,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else if (deliveryState is GetDeliveryCompanyServicesSuccess) {
            return deliveryState.services.isEmpty
                ? Center(
                    child: Text(
                        AppLocalizations.of(context).translate('no_items'),
                        style:
                            const TextStyle(color: AppColor.backgroundColor)),
                  )
                : ListView.builder(
                    itemCount: deliveryState.services.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ItemAdsWidget(
                        name: deliveryState.services[index].title,
                        imageUrl:
                            'https://unblast.com/wp-content/uploads/2020/05/Delivery-Service-Illustration.jpg',
                        onTap: () async {
                          bool isWantAdd = await _showAddtoAdsDialog();
                          if (isWantAdd == true) {
                            String amount = (_totalPrice * 100).toString();
                            makePayment(
                                amount: amount,
                                currency: 'aed',
                                title: deliveryState.services[index].title,
                                description:
                                    deliveryState.services[index].description,
                                location: deliveryState
                                        .services[index].owner.address ??
                                    '',
                                imagePath:
                                    'https://unblast.com/wp-content/uploads/2020/05/Delivery-Service-Illustration.jpg',
                                price: deliveryState.services[index].price
                                    .toDouble(),
                                itemId: deliveryState.services[index].id);
                          }
                        },
                      );
                    },
                  );
          } else {
            return const SizedBox();
          }
        },
      );
    } else if (category == 'user') {
      return BlocBuilder<GetUserBloc, GetUserState>(
        bloc: selectedProductBloc,
        builder: (context, selectedProductState) {
          if (selectedProductState is GetSelectedProductsInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (selectedProductState is GetSelectedProductsFailure) {
            final failure = selectedProductState.message;
            return Center(
              child: Text(
                failure,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else if (selectedProductState is GetSelectedProductsSuccess) {
            return selectedProductState.products.isEmpty
                ? Center(
                    child: Text(
                        AppLocalizations.of(context).translate('no_items'),
                        style:
                            const TextStyle(color: AppColor.backgroundColor)),
                  )
                : ListView.builder(
                    itemCount: selectedProductState.products.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ItemAdsWidget(
                        name: selectedProductState.products[index].name,
                        imageUrl: selectedProductState.products[index].imageUrl,
                        onTap: () async {
                          bool isWantAdd = await _showAddtoAdsDialog();
                          if (isWantAdd == true) {
                            String amount = (_totalPrice * 100).toString();
                            makePayment(
                              amount: amount,
                              currency: 'aed',
                              title: selectedProductState.products[index].name,
                              description: selectedProductState
                                  .products[index].description,
                              location: selectedProductState
                                      .products[index].address ??
                                  '',
                              imagePath:
                                  selectedProductState.products[index].imageUrl,
                              price: selectedProductState
                                      .products[index].priceAfterDiscount ??
                                  selectedProductState.products[index].price,
                              itemId: selectedProductState.products[index].id,
                            );
                          }
                        },
                      );
                    },
                  );
          }
          return Container();
        },
      );
    } else {
      return const SizedBox();
    }
  }

  Future<bool> _showAddtoAdsDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<FeesBloc, FeesState>(
          bloc: feesBloc,
          builder: (context, feesState) {
            if (feesState is GetFeesInProgress) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.backgroundColor,
                ),
              );
            } else if (feesState is GetFeesFailure) {
              final failure = feesState.message;
              return Center(
                child: Text(
                  failure,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
            } else if (feesState is GetFeesSuccess) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Dialog(
                  backgroundColor: AppColor.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return SingleChildScrollView(
                        child: Form(
                            key: _formKey,
                            child: Container(
                              padding: const EdgeInsets.all(26),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('add_your_product_to_ad'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColor.backgroundColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    '${AppLocalizations.of(context).translate('start_date')} :',
                                    style: TextStyle(
                                      color: AppColor.backgroundColor,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 2),
                                    child: TextFormField(
                                      controller: startDateController,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      keyboardType: TextInputType.datetime,
                                      readOnly: true,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please select a date';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        //<-- SEE HERE
                                        fillColor:
                                            Colors.green.withOpacity(0.1),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 30)
                                                .flipped,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      onTap: () async {
                                        final date = await pickDate(
                                          context: context,
                                          initialDate: DateTime.now(),
                                        );
                                        if (date == null) {
                                          return;
                                        }
                                        setState(() {
                                          _selectedStartDate =
                                              date.toIso8601String();
                                          startDateController.text =
                                              convertDateToString(
                                                  date.toString());
                                          _totalPrice = calculateTotalAdsPrice(
                                              selectedStartDate:
                                                  _selectedStartDate,
                                              selectedendDate: _selectedEndDate,
                                              value:
                                                  feesState.fees.adsFees ?? 5);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    '${AppLocalizations.of(context).translate('end_date')} :',
                                    style: TextStyle(
                                      color: AppColor.backgroundColor,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 2),
                                    child: TextFormField(
                                      controller: endDateController,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      keyboardType: TextInputType.datetime,
                                      readOnly: true,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please select a date';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        //<-- SEE HERE
                                        fillColor:
                                            Colors.green.withOpacity(0.1),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 30)
                                                .flipped,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      onTap: () async {
                                        final date = await pickDate(
                                          context: context,
                                          initialDate: DateTime.parse(
                                              _selectedEndDate ??
                                                  DateTime.now()
                                                      .toIso8601String()),
                                        );
                                        if (date == null) {
                                          return;
                                        }
                                        setState(() {
                                          _selectedEndDate =
                                              date.toIso8601String();
                                          endDateController.text =
                                              convertDateToString(
                                                  date.toString());
                                          _totalPrice = calculateTotalAdsPrice(
                                              selectedStartDate:
                                                  _selectedStartDate,
                                              selectedendDate: _selectedEndDate,
                                              value:
                                                  feesState.fees.adsFees ?? 5);
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    '${AppLocalizations.of(context).translate('total_amount')}: $_totalPrice AED',
                                    style: TextStyle(
                                      color: AppColor.colorOne,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('year'),
                                        style: TextStyle(
                                          color: AppColor.backgroundColor,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      TextFormField(
                                        controller: yearController,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        decoration: InputDecoration(
                                          filled: true,
                                          //<-- SEE HERE
                                          fillColor:
                                              Colors.green.withOpacity(0.1),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 30)
                                                  .flipped,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'required';
                                          }

                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('الموقع'),
                                        style: TextStyle(
                                          color: AppColor.backgroundColor,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      TextFormField(
                                        controller: locationController,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          filled: true,
                                          //<-- SEE HERE
                                          fillColor:
                                              Colors.green.withOpacity(0.1),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 30)
                                                  .flipped,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'required';
                                          }

                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      Center(
                                        child: addPhotoButton(
                                            context: context,
                                            text: 'add_ads',
                                            onPressed: () async {
                                              if (!_formKey.currentState!
                                                  .validate()) {
                                                return;
                                              }

                                              bool submit =
                                                  await showSubmitAdsPay(
                                                      context: context,
                                                      totalPrice: _totalPrice);
                                              if (submit == true) {
                                                Navigator.of(context).pop(true);
                                              } else {
                                                Navigator.of(context)
                                                    .pop(false);
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      );
                    },
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}

class ItemAdsWidget extends StatelessWidget {
  final String name;
  final String imageUrl;

  final void Function()? onTap;
  const ItemAdsWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 50.h,
              width: 45.w,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70.0, vertical: 50),
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  color: AppColor.backgroundColor,

                  // strokeWidth: 10,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                name,
                style: TextStyle(
                  color: AppColor.backgroundColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // return GestureDetector(
    //   onTap: onTap,
    //   child: Container(
    //     decoration: BoxDecoration(
    //         border: Border(
    //             bottom: BorderSide(color: Colors.grey.withOpacity(0.2)))),
    //     // height: 65.h,
    //     child: Row(
    //       children: [
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(35),
    //           child: CachedNetworkImage(
    //             imageUrl: imageUrl,
    //             height: 50.h,
    //             width: 45.w,
    //             fit: BoxFit.cover,
    //             progressIndicatorBuilder: (context, url, downloadProgress) =>
    //                 Padding(
    //               padding: const EdgeInsets.symmetric(
    //                   horizontal: 70.0, vertical: 50),
    //               child: CircularProgressIndicator(
    //                 value: downloadProgress.progress,
    //                 color: AppColor.backgroundColor,

    //                 // strokeWidth: 10,
    //               ),
    //             ),
    //             errorWidget: (context, url, error) => const Icon(Icons.error),
    //           ),
    //         ),
    //         Expanded(
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 15),
    //             child: Text(
    //               name,
    //               style: TextStyle(
    //                 color: AppColor.backgroundColor,
    //                 fontSize: 15.sp,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
