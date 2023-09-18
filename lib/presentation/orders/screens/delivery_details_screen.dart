import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';

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
  const DeliveryDetailsScreen(
      {super.key,
      required this.userInfo,
      required this.from,
      required this.products,
      required this.totalAmount,
      required this.subTotal,
      required this.serviceFee});
  final UserInfo userInfo;
  final String from;
  final List<CategoryProducts> products;
  final double totalAmount;

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
  final GlobalKey<FormFieldState> _mobileFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _cityFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _addressDetailsFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _floorNumFormFieldKey =
      GlobalKey<FormFieldState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressDetailsController =
      TextEditingController();
  final TextEditingController floorNumController = TextEditingController();
  String? _selectedLocationType;
  final authBloc = sl<AuthBloc>();
  final sendBloc = sl<SendEmailBloc>();
  @override
  void initState() {
    print('1111111 ${widget.totalAmount}');
    print('222 ${widget.subTotal}');
    print('333 ${widget.serviceFee}');

    super.initState();
    authBloc.add(AuthCheckRequested());
    nameController.text = widget.userInfo.username ?? '';
    mobileController.text = widget.userInfo.firstMobile ?? '';
    cityController.text = widget.userInfo.city ?? '';
    addressDetailsController.text = widget.userInfo.addressDetails ?? '';
    floorNumController.text = widget.userInfo.floorNum != null
        ? widget.userInfo.floorNum.toString()
        : '';
    _selectedLocationType = widget.userInfo.locationType ?? '';
  }

  final orderBloc = sl<OrderBloc>();

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery details',
        ),
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: true,
        backgroundColor: AppColor.backgroundColor,
      ),
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
          } else if (emailState is SendEmailDeliverySuccess) {
            stopLoading();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context).translate('success'),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ));
            orderBloc.add(SaveOrderEvent(
                products: widget.products
                    .map((e) => OrderInput(
                        product: e.id,
                        amount: e.price.toDouble(),
                        qty: e.quantity?.toInt() ?? 1))
                    .toList(),
                orderStatus: 'pending',
                grandTotal: widget.totalAmount,
                mobile: mobileController.text,
                serviceFee: widget.serviceFee,
                subTotal: widget.subTotal,
                shippingAddress:
                    '${cityController.text} - ${addressDetailsController.text} - ${floorNumController.text}'));
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const CongsScreen();
            }));
          }
        },
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
                        const Text('Input your location for delivery service'),
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
                            hintText: 'your name',
                            label: const Text('your name'),
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
                          key: _mobileFormFieldKey,
                          style: const TextStyle(color: Colors.black),
                          controller: mobileController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: AppColor.backgroundColor),
                            hintText: 'mobile',
                            label: const Text('mobile'),
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10)
                                .flipped,
                          ),
                          onChanged: (val) {
                            _mobileFormFieldKey.currentState?.validate();
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
                          key: _cityFormFieldKey,
                          style: const TextStyle(color: Colors.black),
                          controller: cityController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: AppColor.backgroundColor),
                            hintText: 'your city',
                            label: const Text('your city'),
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10)
                                .flipped,
                          ),
                          onChanged: (val) {
                            _cityFormFieldKey.currentState?.validate();
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
                          key: _addressDetailsFormFieldKey,
                          style: const TextStyle(color: Colors.black),
                          controller: addressDetailsController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: AppColor.backgroundColor),
                            hintText: 'your address details',
                            label: const Text('your address details'),
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
                            hintText: 'floor number',
                            label: const Text('floor number'),
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
                        const Text(
                          'Location type',
                          style: TextStyle(color: AppColor.backgroundColor),
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
                                  children: const [
                                    Icon(
                                      Icons.work_outline_outlined,
                                      color: AppColor.backgroundColor,
                                    ),
                                    Text('Work')
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
                                  children: const [
                                    Icon(
                                      Icons.home,
                                      color: AppColor.backgroundColor,
                                    ),
                                    Text('Home'),
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
                                if (!_formKey.currentState!.validate()) return;
                                sendBloc.add(SendEmailDeliveryRequestEvent(
                                  toName: nameController.text,
                                  toEmail: authState.user.userInfo.email ?? '',
                                  mobile: mobileController.text,
                                  city: cityController.text,
                                  addressDetails: addressDetailsController.text,
                                  floorNum: floorNumController.text,
                                  subject: 'Order Delivery',
                                  from: widget.from,
                                ));
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
                                        .translate('send'),
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
    );
  }
}
