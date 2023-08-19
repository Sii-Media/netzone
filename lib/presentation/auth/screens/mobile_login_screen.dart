import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/get_otp_code/get_otp_code_bloc.dart';
import 'package:netzoon/presentation/auth/screens/otp_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen>
    with ScreenLoader<MobileLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _mobileFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController _mobileController = TextEditingController();

  String codeNumber = "+971";
  String fullNumber = "";

  final otpBloc = sl<GetOtpCodeBloc>();

  @override
  Widget screen(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocListener<GetOtpCodeBloc, GetOtpCodeState>(
              bloc: otpBloc,
              listener: (context, state) {
                if (state is GetOtpCodeInProgress) {
                  startLoading();
                } else if (state is GetOtpCodeFailure) {
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
                } else if (state is GetOtpCodeSuccess) {
                  stopLoading();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                      'success',
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ));
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return OtpVerifyScreen(
                      mobileNumber: fullNumber,
                      otphash: state.response.data,
                    );
                  }));
                }
              },
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://img.freepik.com/vector-premium/otp-contrasena-solo-uso-autenticacion-2-pasos-proteccion-datos-concepto-seguridad-internet_100456-10200.jpg?w=740',
                        width: 300.w,
                        height: 300.h,
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
                    Text(
                      'التحقق عن طريق رقم الموبايل',
                      style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'أدخل رقم الهاتف المحمول لكي نرسل لك رمز التحقق',
                      style: TextStyle(
                        color: AppColor.backgroundColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CountryCodePicker(
                          onChanged: (countryCode) {
                            setState(() {
                              codeNumber = countryCode.dialCode ?? '';
                            });
                          },
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: 'AE',
                          favorite: const ['+971', 'AE'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,

                          backgroundColor: AppColor.backgroundColor,
                          dialogBackgroundColor: AppColor.backgroundColor,
                          searchStyle: const TextStyle(color: AppColor.black),
                          flagWidth: 22,
                          dialogTextStyle: const TextStyle(
                            color: AppColor.black,
                          ),
                          boxDecoration: BoxDecoration(
                            color: const Color.fromARGB(255, 209, 219, 235)
                                .withOpacity(0.8),
                          ),
                          textStyle: TextStyle(
                            color: AppColor.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                            key: _mobileFormFieldKey,
                            controller: _mobileController,
                            onChanged: (text) {
                              _mobileFormFieldKey.currentState!.validate();
                            },
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'يجب إدخال رقم الهاتف';
                              }
                              return null;
                            },
                            maxLines: 1,
                            maxLength: 10,
                            style: const TextStyle(color: AppColor.black),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(6.0),
                              hintText: 'رقم الهاتف',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.mainGrey,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.mainGrey,
                                  width: 1,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColor.backgroundColor,
                          ),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                        ),
                        child: const Text('تأكيد'),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() {
                            fullNumber = codeNumber + _mobileController.text;
                          });
                          otpBloc
                              .add(GetOtpCodeRequestedEvent(phone: fullNumber));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
