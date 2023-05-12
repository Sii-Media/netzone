import 'package:dio/dio.dart' as dio;
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/advertisements/ads_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/datasource/remote/deals/deals_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/news/news_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/tenders/tenders_remote_data_source.dart';
import 'package:netzoon/data/repositories/advertisments/advertisment_repository_impl.dart';
import 'package:netzoon/data/repositories/auth_repository_impl.dart';
import 'package:netzoon/data/repositories/deals/deals_repository_impl.dart';
import 'package:netzoon/data/repositories/news/news_repositories_impl.dart';
import 'package:netzoon/data/repositories/tenders/tenders_repository_impl.dart';
import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/advertisements/usercases/get_advertisements_usecase.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/auth/usecases/sign_up_use_case.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';
import 'package:netzoon/domain/deals/usecases/get_all_deals_items_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_deals_cat_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_deals_items_by_cat_use_case.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';
import 'package:netzoon/domain/news/usecases/add_news_use_case.dart';
import 'package:netzoon/domain/news/usecases/get_all_news_usecase.dart';
import 'package:netzoon/domain/tenders/repositories/tenders_repository.dart';
import 'package:netzoon/domain/tenders/usecases/get_all_tenders_items.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_cat_use_case.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_items_by_min.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_items_by_max.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:netzoon/presentation/deals/blocs/dealsItems/deals_items_bloc.dart';
import 'package:netzoon/presentation/deals/blocs/deals_category/deals_categoty_bloc.dart';
import 'package:netzoon/presentation/news/blocs/add_news/add_news_bloc.dart';
import 'package:netzoon/presentation/news/blocs/news/news_bloc.dart';
import 'package:netzoon/presentation/tenders/blocs/tendersCategory/tender_cat_bloc.dart';
import 'package:netzoon/presentation/tenders/blocs/tendersItem/tenders_item_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => SignUpBloc(signUpUseCase: sl()));
  sl.registerFactory(() => AdsBlocBloc(getAdvertismentsUseCase: sl()));
  sl.registerFactory(() => NewsBloc(getAllNewsUseCase: sl()));
  sl.registerFactory(() => AddNewsBloc(addNewsUseCase: sl()));
  sl.registerFactory(() => TenderCatBloc(getTendersCategoriesUseCase: sl()));
  sl.registerFactory(() => TendersItemBloc(
      getTendersItemByMin: sl(),
      getTendersItemByMax: sl(),
      getTendersItem: sl()));

  sl.registerFactory(() => DealsCategotyBloc(getDealsCategoriesUseCase: sl()));
  sl.registerFactory(() =>
      DealsItemsBloc(getDealsItemsByCat: sl(), getDealsItemUsecase: sl()));

  // UseCases

  sl.registerLazySingleton(() => SignUpUseCase(authRepository: sl()));
  sl.registerLazySingleton(
      () => GetAdvertismentsUseCase(advertismentRepository: sl()));

  sl.registerLazySingleton(() => GetAllNewsUseCase(newsRepository: sl()));
  sl.registerLazySingleton(() => AddNewsUseCase(newsRepository: sl()));
  sl.registerLazySingleton(
      () => GetTendersCategoriesUseCase(tenderRepository: sl()));

  sl.registerLazySingleton(() => GetTendersItemByMin(tenderRepository: sl()));
  sl.registerLazySingleton(() => GetTendersItemByMax(tenderRepository: sl()));
  sl.registerLazySingleton(() => GetTendersItem(tenderRepository: sl()));

  sl.registerLazySingleton(
      () => GetDealsCategoriesUseCase(dealsRepository: sl()));
  sl.registerLazySingleton(
      () => GetDealsItemsByCatUseCase(dealsRepository: sl()));

  sl.registerLazySingleton(() => GetDealsItemUsecase(dealsRepository: sl()));

  // Repositories

  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<AdvertismentRepository>(() =>
      AdvertismentRepositoryImpl(
          advertismentRemotDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(newsRemoteDataSourse: sl(), networkInfo: sl()));

  sl.registerLazySingleton<TenderRepository>(() =>
      TendersRepositoryImpl(tendersRemoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<DealsRepository>(() =>
      DealsRepositoryImpl(dealsRemoteDataSource: sl(), networkInfo: sl()));

  // DataSourses

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl(), baseUrl: 'http://10.0.2.2:5000'));

  sl.registerLazySingleton<AdvertismentRemotDataSource>(() =>
      AdvertismentRemotDataSourceImpl(sl(), baseUrl: 'http://10.0.2.2:5000'));

  sl.registerLazySingleton<NewsRemoteDataSourse>(
      () => NewsRemoteDataSourseImpl(sl(), baseUrl: 'http://10.0.2.2:5000'));

  sl.registerLazySingleton<TendersRemoteDataSource>(
      () => TendersRemoteDataSourceImpl(sl(), baseUrl: 'http://10.0.2.2:5000'));

  sl.registerLazySingleton<DealsRemoteDataSource>(
      () => DealsRemoteDataSourceImpl(sl(), baseUrl: 'http://10.0.2.2:5000'));

  //! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External

  sl.registerLazySingleton(() => dio.Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
