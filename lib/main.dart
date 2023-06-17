import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/favorites/favorite_blocs/favorites_bloc.dart';
import 'package:netzoon/presentation/language_screen/blocs/language_bloc/language_bloc.dart';
import 'package:netzoon/presentation/splash/splash_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:netzoon/presentation/utils/constants.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<SignUpBloc>()),
          BlocProvider(create: (_) => di.sl<CartBlocBloc>()..add(LoadCart())),
          BlocProvider(
              create: (_) => di.sl<LanguageBloc>()..add(GetLanguage())),
          BlocProvider(
            create: (_) => di.sl<FavoritesBloc>(),
          )
        ],
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            var local = const Locale('ar');
            if (state is LanguageInitial) {
              local =
                  state.lang == 'ar' ? const Locale('ar') : const Locale('en');
            } else if (state is EnglishState) {
              local = const Locale('en');
            } else if (state is ArabicState) {
              local = const Locale('ar');
            }
            return StreamBuilder(
              stream: languageSubject,
              builder: (context, snapshot) {
                return ScreenUtilInit(
                  designSize: const Size(360, 690),
                  minTextAdapt: true,
                  splitScreenMode: true,
                  builder: (BuildContext context, Widget? child) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      locale: local,
                      title: 'First Method',
                      // You can use the library anywhere in the app even in theme
                      theme: ThemeData(
                        primarySwatch: Colors.blue,
                        textTheme: Typography.englishLike2018.apply(
                          fontSizeFactor: 1.sp,
                          fontFamily: "Cairo",
                          bodyColor: AppColor.black,
                        ),
                      ),
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        // Add the following delegate to support Arabic localization
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: const [
                        Locale('en', ""),
                        Locale('ar', ""),
                      ],
                      home: child ?? Container(),
                    );
                  },
                  child: const SplashScreen(),
                );
              },
            );
          },
        ));
  }
}
