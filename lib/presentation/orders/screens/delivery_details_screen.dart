import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/aramex/entities/actual_weight.dart';
import 'package:netzoon/domain/aramex/entities/calculate_rate_input_data.dart';
import 'package:netzoon/domain/aramex/entities/client_info.dart';
import 'package:netzoon/domain/aramex/entities/party_address.dart';
import 'package:netzoon/domain/aramex/entities/rate_shipment_details.dart';
import 'package:netzoon/presentation/aramex/blocs/aramex_bloc/aramex_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/core/blocs/country_bloc/country_bloc.dart';
import 'package:netzoon/presentation/core/helpers/calculate_fee.dart';
import 'package:netzoon/presentation/core/helpers/get_currency_of_country.dart';
import 'package:netzoon/presentation/data/cities.dart';
import 'package:netzoon/presentation/orders/screens/summery_screen.dart';

import '../../../domain/auth/entities/user_info.dart';
import '../../../domain/departments/entities/category_products/category_products.dart';
import '../../../domain/order/entities/order_input.dart';
import '../../../injection_container.dart';
import '../../contact/blocs/send_email/send_email_bloc.dart';
import '../../core/constant/colors.dart';
import '../../core/widgets/screen_loader.dart';
import '../../utils/app_localizations.dart';
import '../blocs/bloc/my_order_bloc.dart';
import 'congs_screen.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  const DeliveryDetailsScreen({
    super.key,
    required this.userInfo,
    required this.from,
    required this.products,
    required this.totalAmount,
    required this.subTotal,
    required this.serviceFee,
    required this.productsNames,
  });
  final UserInfo userInfo;
  final String from;
  final List<CategoryProducts> products;
  final double totalAmount;
  final String productsNames;
  final double subTotal;
  final double serviceFee;
  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen>
    with ScreenLoader<DeliveryDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _nameFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _phoneNumberFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _cityFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _addressDetailsFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _floorNumFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _cellPhoneFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressDetailsController =
      TextEditingController();
  final TextEditingController floorNumController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cellPhoneController = TextEditingController();
  String? _selectedLocationType;
  final authBloc = sl<AuthBloc>();
  final sendBloc = sl<SendEmailBloc>();
  late final CartBlocBloc cartBloc;
  late final CountryBloc countryBloc;

  double totalPrice = 0;
  late double totalAmount = 0;
  late double serviceFee = 0;

  String selectedCity = 'Abadilah';
  @override
  void initState() {
    super.initState();
    authBloc.add(AuthCheckRequested());
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    cartBloc = BlocProvider.of<CartBlocBloc>(context);
    nameController.text = widget.userInfo.username ?? '';
    emailController.text = widget.userInfo.email ?? '';
    phoneNumberController.text = widget.userInfo.firstMobile ?? '';
    cityController.text = widget.userInfo.city ?? '';
    addressDetailsController.text = widget.userInfo.addressDetails ?? '';
    floorNumController.text = widget.userInfo.floorNum != null
        ? widget.userInfo.floorNum.toString()
        : '';
    _selectedLocationType = widget.userInfo.locationType ?? '';
    print('1');
    DateTime date = DateTime.now();
    // DateTime date = DateTime.parse(dateString);
    int milliseconds = date.millisecondsSinceEpoch;
    DateTime lastPickupTime = date.add(const Duration(days: 3));
    print(milliseconds);
    print(lastPickupTime.millisecondsSinceEpoch);
  }

  final orderBloc = sl<OrderBloc>();
  final aramexBloc = sl<AramexBloc>();
  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('delivery_details'),
        ),
        // leading: const SizedBox(),
        // leadingWidth: 0,
        centerTitle: true,
        backgroundColor: AppColor.backgroundColor,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SendEmailBloc, SendEmailState>(
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
              } else if (emailState is SendEmailDeliverySuccess) {
                stopLoading();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('success'),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ));
                orderBloc.add(SaveOrderEvent(
                    clientId: widget.products[0].owner.id,
                    products: widget.products
                        .map((e) => OrderInput(
                            product: e.id,
                            amount: e.price.toDouble(),
                            qty: e.cartQty?.toInt() ?? 1))
                        .toList(),
                    orderStatus: 'pending',
                    grandTotal: widget.totalAmount,
                    mobile: phoneNumberController.text,
                    serviceFee: widget.serviceFee,
                    subTotal: widget.subTotal,
                    shippingAddress:
                        '//${cityController.text} - ${addressDetailsController.text} - ${floorNumController.text}'));
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const CongsScreen();
                }));
              }
            },
          ),
          BlocListener<AramexBloc, AramexState>(
            bloc: aramexBloc,
            listener: (context, aramexState) {
              if (aramexState is CalculateRateInProgress) {
                startLoading();
              } else if (aramexState is CalculateRateFailure) {
                stopLoading();

                final failure = aramexState.message;
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
              } else if (aramexState is CalculateRateSuccess) {
                stopLoading();
                if (aramexState.calculateRateResponse.hasError == false) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      AppLocalizations.of(context).translate('success'),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ));
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SummeryOrderScreen(
                        products: widget.products,
                        totalAmount: widget.totalAmount,
                        serviceFee: widget.serviceFee,
                        deliveryFee:
                            aramexState.calculateRateResponse.totalAmount.value,
                        toName: nameController.text,
                        toEmail: emailController.text,
                        userMobile: phoneNumberController.text,
                        phoneNumber: cellPhoneController.text,
                        city: selectedCity,
                        subTotal: widget.subTotal,
                        addressDetails: addressDetailsController.text,
                        floorNum: floorNumController.text,
                        subject: 'Order',
                        from: widget.from,
                        productsNames: widget.productsNames,
                        grandTotal: widget.totalAmount.toString());
                  }));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        aramexState
                            .calculateRateResponse.notifications.first.message,
                        style: const TextStyle(
                          color: AppColor.white,
                        ),
                      ),
                      backgroundColor: AppColor.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: authBloc,
          builder: (context, authState) {
            if (authState is Authenticated) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context).translate(
                            'input_your_location_for_delivery_service')),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          key: _nameFormFieldKey,
                          style: const TextStyle(color: Colors.black),
                          controller: nameController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: AppColor.backgroundColor),
                            hintText: AppLocalizations.of(context)
                                .translate('your name'),
                            label: Text(AppLocalizations.of(context)
                                .translate('your name')),
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10)
                                .flipped,
                          ),
                          onChanged: (val) {
                            _nameFormFieldKey.currentState?.validate();
                          },
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('required');
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          key: _emailFormFieldKey,
                          style: const TextStyle(color: Colors.black),
                          controller: emailController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: AppColor.backgroundColor),
                            hintText:
                                AppLocalizations.of(context).translate('email'),
                            label: Text(AppLocalizations.of(context)
                                .translate('email')),
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10)
                                .flipped,
                          ),
                          onChanged: (val) {
                            _emailFormFieldKey.currentState?.validate();
                          },
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('required');
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          key: _phoneNumberFormFieldKey,
                          style: const TextStyle(color: Colors.black),
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: AppColor.backgroundColor),
                            hintText:
                                AppLocalizations.of(context).translate('phone'),
                            label: Text(AppLocalizations.of(context)
                                .translate('phone')),
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10)
                                .flipped,
                          ),
                          onChanged: (val) {
                            _phoneNumberFormFieldKey.currentState?.validate();
                          },
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('required');
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          key: _cellPhoneFormFieldKey,
                          style: const TextStyle(color: Colors.black),
                          controller: cellPhoneController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: AppColor.backgroundColor),
                            hintText: AppLocalizations.of(context)
                                .translate('mobile'),
                            label: Text(AppLocalizations.of(context)
                                .translate('mobile')),
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10)
                                .flipped,
                          ),
                          onChanged: (val) {
                            _cellPhoneFormFieldKey.currentState?.validate();
                          },
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('required');
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        const Text(
                          'Select city',
                          style: TextStyle(fontSize: 14),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            // margin: const EdgeInsets.symmetric(
                            //         horizontal: 2, vertical: 10)
                            //     .r,
                            // Add some padding and a background color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                // color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColor.black,
                                )),
                            // Create the dropdown button
                            child: DropdownButton<String>(
                              // Set the selected value
                              value: selectedCity,
                              menuMaxHeight: 200.h,
                              itemHeight: 50.h,
                              // Handle the value change
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCity = newValue ?? '';
                                });
                              },
                              // Map each option to a widget
                              items: cities.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  // Use a colored box to show the option
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                            )),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          key: _addressDetailsFormFieldKey,
                          style: const TextStyle(color: Colors.black),
                          controller: addressDetailsController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: AppColor.backgroundColor),
                            hintText: AppLocalizations.of(context)
                                .translate('your_address_details'),
                            label: Text(AppLocalizations.of(context)
                                .translate('your_address_details')),
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10)
                                .flipped,
                          ),
                          onChanged: (val) {
                            _addressDetailsFormFieldKey.currentState
                                ?.validate();
                          },
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('required');
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          key: _floorNumFormFieldKey,
                          style: const TextStyle(color: Colors.black),
                          controller: floorNumController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: AppColor.backgroundColor),
                            hintText: AppLocalizations.of(context)
                                .translate('floor_number'),
                            label: Text(AppLocalizations.of(context)
                                .translate('floor_number')),
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10)
                                .flipped,
                          ),
                          onChanged: (val) {
                            _floorNumFormFieldKey.currentState?.validate();
                          },
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('required');
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate('location_type'),
                          style:
                              const TextStyle(color: AppColor.backgroundColor),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: 'work',
                                  groupValue: _selectedLocationType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedLocationType = value ?? '';
                                    });
                                  },
                                  activeColor: AppColor.backgroundColor,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.work_outline_outlined,
                                      color: AppColor.backgroundColor,
                                    ),
                                    Text(AppLocalizations.of(context)
                                        .translate('work'))
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 'home',
                                  groupValue: _selectedLocationType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedLocationType = value ?? "";
                                    });
                                  },
                                  activeColor: AppColor.backgroundColor,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.home,
                                      color: AppColor.backgroundColor,
                                    ),
                                    Text(AppLocalizations.of(context)
                                        .translate('home')),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: InkWell(
                              onTap: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                double totalWeight = 0.0;
                                for (CategoryProducts product
                                    in widget.products) {
                                  totalWeight += product.weight ?? 0;
                                }

                                aramexBloc.add(
                                  CalculateRateEvent(
                                    calculateRateInputData:
                                        CalculateRateInputData(
                                      originAddress: PartyAddress(
                                        line1:
                                            widget.products[0].owner.address ??
                                                '',
                                        line2: '',
                                        line3: "",
                                        city: widget.products[0].owner.city ??
                                            'Dubai',
                                        stateOrProvinceCode:
                                            widget.products[0].owner.city ??
                                                'Dubai',
                                        postCode: '',
                                        countryCode: 'AE',
                                        longitude: 0,
                                        latitude: 0,
                                      ),
                                      destinationAddress: PartyAddress(
                                        line1: addressDetailsController.text,
                                        line2: '',
                                        line3: "",
                                        city: selectedCity,
                                        stateOrProvinceCode: selectedCity,
                                        postCode: '',
                                        countryCode: 'AE',
                                        longitude: 0,
                                        latitude: 0,
                                      ),
                                      shipmentDetails: RateShipmentDetails(
                                          actualWeight: ActualWeight(
                                              unit: 'KG', value: totalWeight),
                                          chargeableWeight: const ActualWeight(
                                              unit: 'KG', value: 0.0),
                                          numberOfPieces:
                                              widget.products.length,
                                          productGroup: 'DOM',
                                          productType: 'ONP',
                                          paymentType: 'P'),
                                      preferredCurrencyCode: 'AED',
                                      clientInfo: const ClientInfo(
                                          source: 24,
                                          accountCountryCode: 'AE',
                                          accountEntity: 'DXB',
                                          accountPin: '116216',
                                          accountNumber: '45796',
                                          userName: 'testingapi@aramex.com',
                                          password: 'R123456789\$r',
                                          version: 'v1'),
                                    ),
                                  ),
                                );
                                // sendBloc.add(SendEmailDeliveryRequestEvent(
                                //   toName: nameController.text,
                                //   toEmail:
                                //       authState.user.userInfo.email ?? '',
                                //   mobile: phoneNumberController.text,
                                //   city: cityController.text,
                                //   addressDetails:
                                //       addressDetailsController.text,
                                //   floorNum: floorNumController.text,
                                //   subject: 'Order Delivery',
                                //   from: widget.from,
                                // ));
                                String amount =
                                    (widget.totalAmount.toInt() * 100)
                                        .toString();
                                // makePayment(amount: amount, currency: 'AED');
                                // Navigator.of(context)
                                //     .push(MaterialPageRoute(builder: (context) {
                                //   return SummeryOrderScreen(
                                //       products: widget.products,
                                //       totalAmount: widget.totalAmount,
                                //       serviceFee: widget.serviceFee,
                                //       deliveryFee: 300,
                                //       toName: nameController.text,
                                //       toEmail: emailController.text,
                                //       userMobile: phoneNumberController.text,
                                //       city: cityController.text,
                                //       subTotal: widget.subTotal,
                                //       addressDetails:
                                //           addressDetailsController.text,
                                //       floorNum: floorNumController.text,
                                //       subject: 'Order',
                                //       from: widget.from,
                                //       productsNames: widget.productsNames,
                                //       grandTotal:
                                //           widget.totalAmount.toString());
                                // }));
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 40.h,
                                width: 200.w,
                                color: AppColor.backgroundColor,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('check_out'),
                                    style: TextStyle(
                                        fontSize: 15.sp, color: AppColor.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.only(bottom: 2.h),
      //   child: BlocBuilder<AuthBloc, AuthState>(
      //     bloc: authBloc,
      //     builder: (context, authState) {
      //       if (authState is Authenticated) {
      //         return BlocBuilder<CountryBloc, CountryState>(
      //           bloc: countryBloc,
      //           builder: (context, countryState) {
      //             return BlocBuilder<CartBlocBloc, CartBlocState>(
      //               builder: (context, state) {
      //                 totalAmount = state is CartLoaded
      //                     ? authState.user.userInfo.userType == 'trader' ||
      //                             authState.user.userInfo.userType ==
      //                                 'local_company'
      //                         ? state.totalPrice +
      //                             calculateTraderFee(items: state.items)
      //                         : state.totalPrice +
      //                             calculatePurchaseFee(state.totalPrice)
      //                     : 0;
      //                 serviceFee = state is CartLoaded
      //                     ? authState.user.userInfo.userType == 'local_company'
      //                         ? calculateTraderFee(items: state.items)
      //                         : calculatePurchaseFee(state.totalPrice)
      //                     : 0;
      //                 return BottomAppBar(
      //                   // elevation: 1,
      //                   // color: Colors.red,
      //                   child: Container(
      //                     padding: const EdgeInsets.symmetric(
      //                       horizontal: 20,
      //                       vertical: 10,
      //                     ),
      //                     height: 220.h,
      //                     decoration: const BoxDecoration(
      //                         color: AppColor.backgroundColor,
      //                         borderRadius: BorderRadius.only(
      //                           topLeft: Radius.circular(30),
      //                           topRight: Radius.circular(30),
      //                         )),
      //                     child: Column(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         Row(
      //                           mainAxisAlignment:
      //                               MainAxisAlignment.spaceBetween,
      //                           children: [
      //                             Text(
      //                               AppLocalizations.of(context)
      //                                   .translate('order_total'),
      //                               style: TextStyle(
      //                                 color: AppColor.white,
      //                                 fontSize: 17.sp,
      //                                 fontWeight: FontWeight.bold,
      //                               ),
      //                             ),
      //                             RichText(
      //                               text: TextSpan(
      //                                   style: TextStyle(
      //                                     fontSize: 17.sp,
      //                                     color: AppColor.white,
      //                                     fontWeight: FontWeight.w700,
      //                                   ),
      //                                   children: <TextSpan>[
      //                                     TextSpan(
      //                                       text: state is CartLoaded
      //                                           ? '${state.totalPrice}'
      //                                           : '0',
      //                                       style: const TextStyle(
      //                                         fontWeight: FontWeight.w700,
      //                                       ),
      //                                     ),
      //                                     TextSpan(
      //                                       text: getCurrencyFromCountry(
      //                                         countryState.selectedCountry,
      //                                         context,
      //                                       ),
      //                                       style: TextStyle(
      //                                           color: AppColor.white,
      //                                           fontSize: 10.sp),
      //                                     )
      //                                   ]),
      //                             ),
      //                           ],
      //                         ),
      //                         Row(
      //                           mainAxisAlignment:
      //                               MainAxisAlignment.spaceBetween,
      //                           children: [
      //                             Text(
      //                               AppLocalizations.of(context)
      //                                   .translate('service_fee'),
      //                               style: TextStyle(
      //                                 color: AppColor.white,
      //                                 fontSize: 17.sp,
      //                                 fontWeight: FontWeight.w700,
      //                               ),
      //                             ),
      //                             // Text(
      //                             //   state is CartLoaded
      //                             //       ? authState.user.userInfo.userType ==
      //                             //               'local_company'
      //                             //           ? '${calculateTraderFee(items: state.items)}AED'
      //                             //           : '${calculatePurchaseFee(state.totalPrice)}'
      //                             //       : '0',
      //                             //   style: TextStyle(
      //                             //     color: AppColor.white,
      //                             //     fontSize: 17.sp,
      //                             //     fontWeight: FontWeight.w700,
      //                             //   ),
      //                             // ),
      //                             RichText(
      //                               text: TextSpan(
      //                                   style: TextStyle(
      //                                     fontSize: 17.sp,
      //                                     color: AppColor.white,
      //                                     fontWeight: FontWeight.w700,
      //                                   ),
      //                                   children: <TextSpan>[
      //                                     TextSpan(
      //                                       text: state is CartLoaded
      //                                           ? authState.user.userInfo
      //                                                       .userType ==
      //                                                   'local_company'
      //                                               ? '${calculateTraderFee(items: state.items)}'
      //                                               : '${calculatePurchaseFee(state.totalPrice)}'
      //                                           : '0',
      //                                       style: const TextStyle(
      //                                         fontWeight: FontWeight.w700,
      //                                       ),
      //                                     ),
      //                                     TextSpan(
      //                                       text: getCurrencyFromCountry(
      //                                         countryState.selectedCountry,
      //                                         context,
      //                                       ),
      //                                       style: TextStyle(
      //                                           color: AppColor.white,
      //                                           fontSize: 10.sp),
      //                                     )
      //                                   ]),
      //                             ),
      //                           ],
      //                         ),
      //                         const Divider(
      //                           color: AppColor.mainGrey,
      //                           thickness: 1,
      //                         ),
      //                         Row(
      //                           mainAxisAlignment:
      //                               MainAxisAlignment.spaceBetween,
      //                           children: [
      //                             Text(
      //                               AppLocalizations.of(context)
      //                                   .translate('total_amount'),
      //                               style: TextStyle(
      //                                 color: AppColor.white,
      //                                 fontSize: 17.sp,
      //                                 fontWeight: FontWeight.w700,
      //                               ),
      //                             ),
      //                             // Text(
      //                             //   state is CartLoaded
      //                             //       ? authState.user.userInfo.userType ==
      //                             //                   'trader' ||
      //                             //               authState.user.userInfo
      //                             //                       .userType ==
      //                             //                   'local_company'
      //                             //           ? '${state.totalPrice + calculateTraderFee(items: state.items)} AED'
      //                             //           : '${state.totalPrice + calculatePurchaseFee(state.totalPrice)}AED'
      //                             //       : '0AED',
      //                             //   style: TextStyle(
      //                             //     color: AppColor.white,
      //                             //     fontSize: 17.sp,
      //                             //     fontWeight: FontWeight.w700,
      //                             //   ),
      //                             // ),
      //                             RichText(
      //                               text: TextSpan(
      //                                   style: TextStyle(
      //                                     fontSize: 17.sp,
      //                                     color: AppColor.white,
      //                                     fontWeight: FontWeight.w700,
      //                                   ),
      //                                   children: <TextSpan>[
      //                                     TextSpan(
      //                                       text: state is CartLoaded
      //                                           ? authState.user.userInfo
      //                                                           .userType ==
      //                                                       'trader' ||
      //                                                   authState.user.userInfo
      //                                                           .userType ==
      //                                                       'local_company'
      //                                               ? '${state.totalPrice + calculateTraderFee(items: state.items)}'
      //                                               : '${state.totalPrice + calculatePurchaseFee(state.totalPrice)}'
      //                                           : '0',
      //                                       style: const TextStyle(
      //                                         fontWeight: FontWeight.w700,
      //                                       ),
      //                                     ),
      //                                     TextSpan(
      //                                       text: getCurrencyFromCountry(
      //                                         countryState.selectedCountry,
      //                                         context,
      //                                       ),
      //                                       style: TextStyle(
      //                                           color: AppColor.white,
      //                                           fontSize: 10.sp),
      //                                     )
      //                                   ]),
      //                             ),
      //                           ],
      //                         ),
      //                         InkWell(
      //                           onTap: () {
      //                             if (!_formKey.currentState!.validate()) {
      //                               return;
      //                             }
      //                             String amount =
      //                                 (widget.totalAmount.toInt() * 100)
      //                                     .toString();
      //                             makePayment(amount: amount, currency: 'AED');
      //                           },
      //                           child: Container(
      //                             alignment: Alignment.center,
      //                             width: double.infinity,
      //                             height: 50.h,
      //                             decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(20),
      //                                 border:
      //                                     Border.all(color: AppColor.white)),
      //                             child: Text(
      //                               AppLocalizations.of(context)
      //                                   .translate('confirm'),
      //                               style: TextStyle(
      //                                 fontSize: 16.sp,
      //                                 fontWeight: FontWeight.bold,
      //                                 color: AppColor.white,
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               },
      //             );
      //           },
      //         );
      //       }
      //       return const SizedBox();
      //     },
      //   ),
      // ),
    );
  }
}
