import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/legal_advice/blocs/legal_advice/legal_advice_bloc.dart';

class LegalAdviceScreen extends StatefulWidget {
  const LegalAdviceScreen({super.key});

  @override
  State<LegalAdviceScreen> createState() => _LegalAdviceScreenState();
}

class _LegalAdviceScreenState extends State<LegalAdviceScreen> {
  final LegalAdviceBloc adviceBloc = sl<LegalAdviceBloc>();

  @override
  void initState() {
    adviceBloc.add(GetLegalAdviceEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController search = TextEditingController();

    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SizedBox(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration:
                      const BoxDecoration(color: AppColor.backgroundColor),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/00.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: search,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColor.white,
                            suffixIcon: InkWell(
                                child: const Icon(Icons.search), onTap: () {}),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            hintText: 'البحث في netzoon.com',
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(
                              fontSize: 8.sp,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 30),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 135.w,
                      height: 130.h,
                      padding: const EdgeInsets.only(left: 0, right: 5),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/logo.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 150.h,
                child: Center(
                  child: Text(
                    'استشارات قانونية',
                    style: TextStyle(fontSize: 22.sp, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: 202.h,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: size.height - 200.h,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                    child: BlocBuilder<LegalAdviceBloc, LegalAdviceState>(
                      bloc: adviceBloc,
                      builder: (context, state) {
                        if (state is LegalAdviceProgress) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.backgroundColor,
                            ),
                          );
                        } else if (state is LegalAdviceFailure) {
                          final failure = state.message;
                          return Center(
                            child: Text(
                              failure,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          );
                        } else if (state is LegalAdviceSuccess) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.legalAdvices.length,
                            itemBuilder: (BuildContext context, index) {
                              return Text(
                                state.legalAdvices[index].text,
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 14.sp,
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
