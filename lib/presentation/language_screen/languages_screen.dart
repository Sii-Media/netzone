import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/language_screen/blocs/language_bloc/language_bloc.dart';
import 'package:netzoon/presentation/language_screen/widgets/buttom_lang_widget.dart';

class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BackgroundWidget(
        widget: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'اختيار اللغة',
                  style: TextStyle(
                    color: AppColor.backgroundColor,
                    fontSize: 25.sp,
                  ),
                ),
                const SizedBox(height: 20),
                ButtonLangWidget(
                    textButton: "Ar",
                    onPressed: () {
                      BlocProvider.of<LanguageBloc>(context)
                          .add(const ChooseOnetherLang('ar'));
                    }),
                ButtonLangWidget(
                    textButton: "En",
                    onPressed: () {
                      BlocProvider.of<LanguageBloc>(context)
                          .add(const ChooseOnetherLang('en'));
                    }),
              ],
            )),
      ),
    );
  }
}
