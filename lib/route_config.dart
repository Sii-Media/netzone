import 'package:go_router/go_router.dart';
import 'package:netzoon/presentation/advertising/advertising_details.dart';
import 'package:netzoon/presentation/advertising/another_ads_details.dart';
import 'package:netzoon/presentation/advertising/advertising.dart';
import 'package:netzoon/presentation/auth/screens/reset_password_screen.dart';
import 'package:netzoon/presentation/categories/delivery_company/screens/delivery_companies_list_screen.dart';
import 'package:netzoon/presentation/categories/delivery_company/screens/delivery_company_profile_screen.dart';
import 'package:netzoon/presentation/categories/factories/factories_categories.dart';
import 'package:netzoon/presentation/categories/factories/factory_profile_screen.dart';
import 'package:netzoon/presentation/categories/free_zoon/freezone_companies_list_screen.dart';
import 'package:netzoon/presentation/categories/local_company/company_service_detail_screen.dart';
import 'package:netzoon/presentation/categories/local_company/local_companies.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_profile.dart';
import 'package:netzoon/presentation/categories/main_categories.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_companies_list_screen.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_company_profile_screen.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_details_screen.dart';
import 'package:netzoon/presentation/categories/users/screens/users_list_screen.dart';
import 'package:netzoon/presentation/categories/users/screens/users_profile_screen.dart';
import 'package:netzoon/presentation/categories/vehicles/screens/vehicle_companies_profile_screen.dart';
import 'package:netzoon/presentation/categories/vehicles/screens/vehicles_companies_screen.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';
import 'package:netzoon/presentation/core/widgets/vehicle_details.dart';
import 'package:netzoon/presentation/home/test.dart';
import 'package:netzoon/presentation/news/news_details.dart';
import 'package:netzoon/presentation/news/news_screen.dart';
import 'package:netzoon/presentation/onboarding/onboarding_screen.dart';
import 'package:netzoon/presentation/splash/splash_screen.dart';
import 'package:netzoon/presentation/start_screen.dart';

class RouteConfig {
  static GoRouter getRouter() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
          routes: [
            GoRoute(
              path: 'start',
              builder: (context, state) => const StartScreen(),
            ),
            // GoRoute(
            //   path: 'onboarding',
            //   builder: (context, state) => const OnBoardingScreen(),
            // ),
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
              path: 'real_estate/:id',
              builder: (context, state) => RealEstateDetailsScreen(
                  realEstateId: state.pathParameters['id'].toString()),
            ),
            GoRoute(
              path: 'vehicle/:id',
              builder: (context, state) => VehicleDetailsScreen(
                  vehicleId: state.pathParameters['id'].toString()),
            ),
            GoRoute(
              path: 'news',
              builder: (context, state) => const NewsScreen(),
              routes: [
                GoRoute(
                  path: 'news_details/:id',
                  builder: (context, state) => NewsDetails(
                      newsId: state.pathParameters['id'].toString()),
                ),
              ],
            ),
            GoRoute(
              path: 'advertisments',
              builder: (context, state) => const AdvertisingScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) => AdvertismentDetalsScreen(
                      adsId: state.pathParameters['id'].toString()),
                ),
              ],
            ),
            GoRoute(
              path: 'ads',
              builder: (context, state) => const AdvertisingScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) => AnotherAdsDetails(
                      adsId: state.pathParameters['id'].toString()),
                ),
              ],
            ),
            GoRoute(
              path: 'services/:id',
              builder: (context, state) => CompanyServiceDetailsScreen(
                  companyServiceId: state.pathParameters['id'].toString()),
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
                      builder: (context, state) =>
                          RealEstateCompanyProfileScreen(
                              id: state.pathParameters['id'].toString()),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'freezone',
                  builder: (context, state) =>
                      const FreeZoneCompaniesListScreen(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (context, state) => LocalCompanyProfileScreen(
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
                      builder: (context, state) =>
                          VehicleCompaniesProfileScreen(
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
                      builder: (context, state) =>
                          VehicleCompaniesProfileScreen(
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
                      builder: (context, state) =>
                          VehicleCompaniesProfileScreen(
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
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (context, state) => DeliveryCompanyProfileScreen(
                          id: state.pathParameters['id'].toString()),
                    )
                  ],
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
  }
}
