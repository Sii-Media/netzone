import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/get_otp_code/get_otp_code_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? otphash;
  const OtpVerifyScreen({super.key, this.mobileNumber, this.otphash});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen>
    with ScreenLoader<OtpVerifyScreen> {
  String _otpCode = "";
  final int _otpCodeLength = 4;
  late FocusNode myFocusNode;

  @override
  void initState() {
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();
    SmsAutoFill().listenForCode.call();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    myFocusNode.dispose();
    super.dispose();
  }

  final otpBloc = sl<GetOtpCodeBloc>();
  @override
  Widget screen(BuildContext context) {
    return Scaffold(
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
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) {
                //   return OtpVerifyScreen(
                //     mobileNumber: fullNumber,
                //     otphash: state.response.data,
                //   );
                // }));
              }
            },
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
                  ),
                ),
                Text(
                  'رمز التحقق',
                  style: TextStyle(
                      color: AppColor.backgroundColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'الرجاء ادخال رمز التحقق الذي ارسلناه لك',
                  style: TextStyle(
                    color: AppColor.backgroundColor,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: PinFieldAutoFill(
                    decoration: UnderlineDecoration(
                      textStyle: const TextStyle(
                        color: AppColor.black,
                        fontSize: 20,
                      ),
                      colorBuilder: FixedColorBuilder(
                        AppColor.black.withOpacity(0.3),
                      ),
                    ),
                    currentCode: _otpCode,
                    codeLength: _otpCodeLength,
                    onCodeChanged: (code) {
                      if (code!.length == _otpCodeLength) {
                        _otpCode = code;
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20.h,
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
                    child: const Text('متابعة'),
                    onPressed: () async {
                      otpBloc.add(VerifyOtpCodeEvent(
                        phone: widget.mobileNumber!,
                        otp: _otpCode,
                        hash: widget.otphash!,
                      ));
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return OtpVerifyScreen();
                      // }));
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
