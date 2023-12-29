import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/presentation/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:netzoon/presentation/auth/screens/reset_password_screen.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/categories/delivery_company/screens/delivery_companies_list_screen.dart';
import 'package:netzoon/presentation/categories/factories/factories_categories.dart';
import 'package:netzoon/presentation/categories/factories/factories_screen.dart';
import 'package:netzoon/presentation/categories/factories/factory_profile_screen.dart';
import 'package:netzoon/presentation/categories/free_zoon/freezone_companies_list_screen.dart';
import 'package:netzoon/presentation/categories/free_zoon/freezone_company_profile_screen.dart';
import 'package:netzoon/presentation/categories/local_company/local_companies.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_profile.dart';
import 'package:netzoon/presentation/categories/main_categories.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_companies_list_screen.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_company_profile_screen.dart';
import 'package:netzoon/presentation/categories/users/screens/users_list_screen.dart';
import 'package:netzoon/presentation/categories/users/screens/users_profile_screen.dart';
import 'package:netzoon/presentation/categories/vehicles/screens/vehicle_companies_profile_screen.dart';
import 'package:netzoon/presentation/categories/vehicles/screens/vehicles_companies_screen.dart';
import 'package:netzoon/presentation/core/blocs/country_bloc/country_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';
import 'package:netzoon/presentation/favorites/favorite_blocs/favorites_bloc.dart';
import 'package:netzoon/presentation/home/test.dart';
import 'package:netzoon/presentation/language_screen/blocs/language_bloc/language_bloc.dart';
import 'package:netzoon/presentation/news/news_details.dart';
import 'package:netzoon/presentation/news/news_screen.dart';
import 'package:netzoon/presentation/notifications/blocs/notifications/notifications_bloc.dart';
import 'package:netzoon/presentation/notifications/screens/notification_screen.dart';
import 'package:netzoon/presentation/splash/splash_screen.dart';
import 'package:netzoon/presentation/start_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:netzoon/presentation/utils/constants.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColor.white,
    statusBarIconBrightness: Brightness.dark,
  ));
  // String stripePubKey = dotenv.get('STRIPE_LIVE_PUB_KEY', fallback: '');
  String stripePubKey =
      'pk_live_51NcotDFDslnmTEHTPtLglOb3AT42QjZZVLq1vf8tJnIPfdFg1KuICUbY7E2dgVNbbx6GLmzAfezZ55ECVftwhVRy00Aa4dpTFg';
  Stripe.publishableKey = stripePubKey;
  print('Stripe : $stripePubKey');
  // await initializeQuickBlox();
  await Firebase.initializeApp();
  if (Platform.isIOS) {
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      await FirebaseMessaging.instance.subscribeToTopic('Netzoon');
    } else {
      await Future<void>.delayed(
        const Duration(
          seconds: 3,
        ),
      );
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        await FirebaseMessaging.instance.subscribeToTopic('Netzoon');
      }
    }
  } else {
    await FirebaseMessaging.instance.subscribeToTopic('Netzoon');
  }
  // await FirebaseMessaging.instance.subscribeToTopic('Netzoon');
  // FirebaseMessaging.instance
  //     .getToken()
  //     // ignore: avoid_print
  //     .then((value) => {print('getToken : $value')});
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    handleMessage(message);
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      handleMessage(message);
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await di.init();
  runApp(MyApp());

  FirebaseMessaging.onMessage.listen((message) {
    final notification = message.notification;
    final notiBloc = sl<NotificationsBloc>();

    if (notification == null) return;
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@drawable/ic_launcher',
        ),
      ),
      payload: jsonEncode(message.toMap()),
    );
    notiBloc.add(GetUnreadNotificationsEvent());
  });
  initLocalNotifications();
}

Future initLocalNotifications() async {
  const iOS = DarwinInitializationSettings();
  const android = AndroidInitializationSettings('@drawable/ic_launcher');
  const settings = InitializationSettings(android: android, iOS: iOS);
  await _localNotifications.initialize(settings,
      onDidReceiveNotificationResponse: (payload) {
    final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
    handleMessage(message);
  });
  final platform = _localNotifications.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await platform?.createNotificationChannel(_androidChannel);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

final navigatorKey = GlobalKey<NavigatorState>();

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
  navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) {
    return const NotificatiionScreen();
  }));
}

const _androidChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This Channel Used for important notifications',
  importance: Importance.defaultImportance,
);

final _localNotifications = FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    SendbirdChat.init(appId: 'D27C6110-9DB9-4EBE-AA85-CF39E2AF562E');
  }
  final String cc = 'a';
  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
        routes: [
          GoRoute(
            path: 'start',
            builder: (context, state) => const StartScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const TestScreen(),
        routes: [
          GoRoute(
            path: 'product/:id',
            builder: (context, state) => ProductDetailScreen(
                item: state.pathParameters['id'].toString()),
          ),
          GoRoute(
            path: 'news',
            builder: (context, state) => const NewsScreen(),
            routes: [
              GoRoute(
                path: 'news_details/:id',
                builder: (context, state) =>
                    NewsDetails(newsId: state.pathParameters['id'].toString()),
              ),
            ],
          ),
          GoRoute(
            path: 'catagories',
            builder: (context, state) => const CategoriesMainScreen(),
            routes: [
              GoRoute(
                path: 'local_company',
                builder: (context, state) => const GovernmentalCompanies(
                  userType: 'local_company',
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => LocalCompanyProfileScreen(
                        id: state.pathParameters['id'].toString()),
                  ),
                ],
              ),
              GoRoute(
                path: 'users',
                builder: (context, state) => const UsersListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => UsersProfileScreen(
                        userId: state.pathParameters['id'].toString()),
                  ),
                ],
              ),
              GoRoute(
                path: 'real_estate',
                builder: (context, state) =>
                    const RealEstateCompaniesListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => RealEstateCompanyProfileScreen(
                        id: state.pathParameters['id'].toString()),
                  ),
                ],
              ),
              GoRoute(
                path: 'free_zone_companies',
                builder: (context, state) =>
                    const FreeZoneCompaniesListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => FreezoneCompanyProfileScreen(
                        id: state.pathParameters['id'].toString()),
                  ),
                ],
              ),
              GoRoute(
                path: 'factories',
                builder: (context, state) => const FactoriesCategoryScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => FactoryProfileScreen(
                        id: state.pathParameters['id'].toString()),
                  )
                ],
              ),
              GoRoute(
                path: 'civil_aircraft',
                builder: (context, state) =>
                    const VehiclesCompaniesScreen(type: 'planes'),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => VehicleCompaniesProfileScreen(
                      id: state.pathParameters['id'].toString(),
                      userType: 'planes',
                    ),
                  )
                ],
              ),
              GoRoute(
                path: 'cars',
                builder: (context, state) =>
                    const VehiclesCompaniesScreen(type: 'cars'),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => VehicleCompaniesProfileScreen(
                      id: state.pathParameters['id'].toString(),
                      userType: 'cars',
                    ),
                  )
                ],
              ),
              GoRoute(
                path: 'sea_companies',
                builder: (context, state) =>
                    const VehiclesCompaniesScreen(type: 'sea_companies'),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => VehicleCompaniesProfileScreen(
                      id: state.pathParameters['id'].toString(),
                      userType: 'sea_companies',
                    ),
                  )
                ],
              ),
              GoRoute(
                path: 'trader',
                builder: (context, state) =>
                    const GovernmentalCompanies(userType: 'trader'),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => LocalCompanyProfileScreen(
                        id: state.pathParameters['id'].toString()),
                  )
                ],
              ),
              GoRoute(
                path: 'delivery_companies',
                builder: (context, state) =>
                    const DeliveryCompaniesListScreen(),
                // routes: [
                //   GoRoute(
                //     path: ':id',
                //     builder: (context, state) => LocalCompanyProfileScreen(
                //         id: state.pathParameters['id'].toString()),
                //   )
                // ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/reset-password/:token',
        builder: (context, state) => ResetPasswordScreen(
            token: state.pathParameters['token'].toString()),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<SignUpBloc>()),
          BlocProvider(create: (_) => di.sl<CountryBloc>()),
          BlocProvider(create: (_) => di.sl<CartBlocBloc>()..add(LoadCart())),
          BlocProvider(
              create: (_) => di.sl<NotificationsBloc>()
                ..add(GetUnreadNotificationsEvent())),
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
                    return MaterialApp.router(
                      routerConfig: _router,
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
                          useMaterial3: false),
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        // Add the following delegate to support Arabic localization
                        GlobalCupertinoLocalizations.delegate,
                        CountryLocalizations.delegate,
                      ],
                      supportedLocales: const [
                        Locale('en', ""),
                        Locale('ar', ""),
                      ],
                      builder: (context, child) {
                        return child ?? Container();
                      },
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
