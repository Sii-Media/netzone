import 'package:dio/dio.dart' as dio;
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/local/auth/auth_local_data_source.dart';
import 'package:netzoon/data/datasource/local/lang/lang_local_data_resource.dart';
import 'package:netzoon/data/datasource/remote/advertisements/ads_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/datasource/remote/complaints/complaints_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/deals/deals_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/departments/departments_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/legal_advice/legal_advice_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/news/news_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/openions/openion_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/questions/question_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/requests/requests_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/tenders/tenders_remote_data_source.dart';
import 'package:netzoon/data/repositories/advertisments/advertisment_repository_impl.dart';
import 'package:netzoon/data/repositories/auth_repository_impl.dart';
import 'package:netzoon/data/repositories/complaints/complaints_repository_impl.dart';
import 'package:netzoon/data/repositories/deals/deals_repository_impl.dart';
import 'package:netzoon/data/repositories/departments/departments_repository_impl.dart';
import 'package:netzoon/data/repositories/lang/lang_repository_impl.dart';
import 'package:netzoon/data/repositories/legal_advice/legal_advice_repository_impl.dart';
import 'package:netzoon/data/repositories/news/news_repositories_impl.dart';
import 'package:netzoon/data/repositories/openions/openion_repository_impl.dart';
import 'package:netzoon/data/repositories/questions/question_repository_impl.dart';
import 'package:netzoon/data/repositories/requests/requests_repository_impl.dart';
import 'package:netzoon/data/repositories/tenders/tenders_repository_impl.dart';
import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/advertisements/usercases/add_ads_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/get_ads_by_type_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/get_advertisements_usecase.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/auth/usecases/get_first_time_logged_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_otpcode_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/auth/usecases/logout_use_case.dart';
import 'package:netzoon/domain/auth/usecases/set_first_time_logged_use_case.dart';
import 'package:netzoon/domain/auth/usecases/sign_in_use_case.dart';
import 'package:netzoon/domain/auth/usecases/sign_up_use_case.dart';
import 'package:netzoon/domain/auth/usecases/verify_otp_code_use_case.dart';
import 'package:netzoon/domain/complaints/repositories/complaints_repository.dart';
import 'package:netzoon/domain/complaints/usecases/add_complaints_usecase.dart';
import 'package:netzoon/domain/complaints/usecases/get_complaints_usecase.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';
import 'package:netzoon/domain/deals/usecases/get_all_deals_items_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_deals_cat_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_deals_items_by_cat_use_case.dart';
import 'package:netzoon/domain/departments/repositories/departments_repository.dart';
import 'package:netzoon/domain/departments/usecases/add_product_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_categories_by_departments_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_category_products_use_case.dart';
import 'package:netzoon/domain/lang/repositories/lang_repository.dart';
import 'package:netzoon/domain/lang/usecases/change_language.dart';
import 'package:netzoon/domain/lang/usecases/get_init_language.dart';
import 'package:netzoon/domain/legal_advice/repositories/legal_advice_repository.dart';
import 'package:netzoon/domain/legal_advice/usecases/get_legal_advices_use_case.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';
import 'package:netzoon/domain/news/usecases/add_news_use_case.dart';
import 'package:netzoon/domain/news/usecases/get_all_news_usecase.dart';
import 'package:netzoon/domain/openions/repositories/openion_repository.dart';
import 'package:netzoon/domain/openions/usecases/add_openion_use_case.dart';
import 'package:netzoon/domain/questions/repositories/question_repository.dart';
import 'package:netzoon/domain/questions/usecases/add_question_use_case.dart';
import 'package:netzoon/domain/requests/repositories/requests_repository.dart';
import 'package:netzoon/domain/requests/usecases/add_request_use_case.dart';
import 'package:netzoon/domain/tenders/repositories/tenders_repository.dart';
import 'package:netzoon/domain/tenders/usecases/get_all_tenders_items.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_cat_use_case.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_items_by_min.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_items_by_max.dart';
import 'package:netzoon/presentation/add_items/blocs/bloc/add_product_bloc.dart';
import 'package:netzoon/presentation/advertising/blocs/add_ads/add_ads_bloc.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/get_otp_code/get_otp_code_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/sign_in/sign_in_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/add_complaint/add_complaint_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/add_openion/add_openion_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/add_question/add_question_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/add_request/add_request_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/get_complaints/get_complaint_bloc.dart';
import 'package:netzoon/presentation/deals/blocs/dealsItems/deals_items_bloc.dart';
import 'package:netzoon/presentation/deals/blocs/deals_category/deals_categoty_bloc.dart';
import 'package:netzoon/presentation/home/blocs/elec_devices/elec_devices_bloc.dart';
import 'package:netzoon/presentation/language_screen/blocs/language_bloc/language_bloc.dart';
import 'package:netzoon/presentation/legal_advice/blocs/legal_advice/legal_advice_bloc.dart';
import 'package:netzoon/presentation/news/blocs/add_news/add_news_bloc.dart';
import 'package:netzoon/presentation/news/blocs/news/news_bloc.dart';
import 'package:netzoon/presentation/tenders/blocs/tendersCategory/tender_cat_bloc.dart';
import 'package:netzoon/presentation/tenders/blocs/tendersItem/tenders_item_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'https://net-zoon.onrender.com';
final sl = GetIt.instance;

Future<void> init() async {
  //! Bloc
  sl.registerFactory(() => SignUpBloc(signUpUseCase: sl()));
  sl.registerFactory(() => SignInBloc(signInUseCase: sl()));
  sl.registerFactory(() => AdsBlocBloc(
        getAdvertismentsUseCase: sl(),
        getAdsByTypeUseCase: sl(),
      ));
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

  sl.registerFactory(() => ElecDevicesBloc(
      getCategoriesByDepartmentUsecase: sl(),
      getCategoryProductsUseCase: sl()));

  sl.registerFactory(() => AddProductBloc(addProductUseCase: sl()));
  sl.registerFactory(() => CartBlocBloc());

  sl.registerFactory(() => LegalAdviceBloc(getLegalAdvicesUseCase: sl()));

  sl.registerFactory(() => AddOpenionBloc(addOpenionUseCase: sl()));

  sl.registerFactory(() => AddQuestionBloc(addQuestionUseCase: sl()));

  sl.registerFactory(() => AddRequestBloc(addRequestUseCase: sl()));

  sl.registerFactory(() => GetComplaintBloc(getComplaintsUseCase: sl()));
  sl.registerFactory(() => AddComplaintBloc(addComplaintsUseCase: sl()));

  sl.registerFactory(() => AddAdsBloc(addAdvertisementUseCase: sl()));

  sl.registerFactory(() => AuthBloc(
        getSignedInUser: sl(),
        getFirstTimeLogged: sl(),
        setFirstTimeLogged: sl(),
        logoutUseCase: sl(),
      ));

  sl.registerFactory(() =>
      GetOtpCodeBloc(getOtpCodeUseCase: sl(), verifyOtpCodeUseCase: sl()));

  sl.registerFactory(() => LanguageBloc(
      sharedPreferences: sl(), changeLanguage: sl(), getInitLanguage: sl()));

  //! UseCases
  sl.registerLazySingleton(() => GetSignedInUserUseCase(authRepository: sl()));
  sl.registerLazySingleton(
      () => GetFirstTimeLoggedUseCase(authRepository: sl()));
  sl.registerLazySingleton(
      () => SetFirstTimeLoggedUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignInUseCase(authRepository: sl()));
  sl.registerLazySingleton(
      () => GetAdvertismentsUseCase(advertismentRepository: sl()));

  sl.registerLazySingleton(
      () => GetAdsByTypeUseCase(advertismentRepository: sl()));

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

  sl.registerLazySingleton(
      () => GetCategoriesByDepartmentUsecase(departmentRepository: sl()));

  sl.registerLazySingleton(
      () => GetCategoryProductsUseCase(departmentRepository: sl()));

  sl.registerLazySingleton(() => AddProductUseCase(departmentRepository: sl()));

  sl.registerLazySingleton(
      () => GetLegalAdvicesUseCase(legalAdviceRepository: sl()));

  sl.registerLazySingleton(() => AddOpenionUseCase(openionsRepository: sl()));

  sl.registerLazySingleton(() => AddQuestionUseCase(questionRepository: sl()));

  sl.registerLazySingleton(() => AddRequestUseCase(requestsRepository: sl()));
  sl.registerLazySingleton(
      () => GetComplaintsUseCase(complaintsRepository: sl()));
  sl.registerLazySingleton(
      () => AddComplaintsUseCase(complaintsRepository: sl()));

  sl.registerLazySingleton(
      () => AddAdvertisementUseCase(advertismentRepository: sl()));

  sl.registerLazySingleton(() => GetOtpCodeUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => VerifyOtpCodeUseCase(authRepository: sl()));

  sl.registerLazySingleton(() => ChangeLanguage(languageRepository: sl()));
  sl.registerLazySingleton(() => GetInitLanguage(languageRepository: sl()));

  //! Repositories

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      authRemoteDataSource: sl(), local: sl(), networkInfo: sl()));

  sl.registerLazySingleton<AdvertismentRepository>(() =>
      AdvertismentRepositoryImpl(
          advertismentRemotDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(newsRemoteDataSourse: sl(), networkInfo: sl()));

  sl.registerLazySingleton<TenderRepository>(() =>
      TendersRepositoryImpl(tendersRemoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<DealsRepository>(() =>
      DealsRepositoryImpl(dealsRemoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<DepartmentRepository>(() => DepartmentRepositoryImpl(
      departmentsRemoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<LegalAdviceRepository>(() =>
      LegalAdviceRepositoryImpl(
          networkInfo: sl(), legalAdviceRemoteDataSource: sl()));

  sl.registerLazySingleton<OpenionsRepository>(() => OpenionsRepositoryImpl(
      networkInfo: sl(), openionsRemoteDataSource: sl()));

  sl.registerLazySingleton<QuestionRepository>(() => QuestionRepositoryImpl(
      networkInfo: sl(), questionRemoteDataSource: sl()));

  sl.registerLazySingleton<RequestsRepository>(() => RequestsRepositoryImpl(
      networkInfo: sl(), requestsRemoteDataSource: sl()));

  sl.registerLazySingleton<ComplaintsRepository>(() => ComplaintsRepositoryImpl(
      networkInfo: sl(), complaintsRemoteDataSource: sl()));

  sl.registerLazySingleton<LangRepository>(
      () => LangRepositoryImpl(langLocalDataResource: sl()));

  //! DataSourses

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<AdvertismentRemotDataSource>(
      () => AdvertismentRemotDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<NewsRemoteDataSourse>(
      () => NewsRemoteDataSourseImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<TendersRemoteDataSource>(
      () => TendersRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<DealsRemoteDataSource>(
      () => DealsRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<DepartmentsRemoteDataSource>(
      () => DepartmentsRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<LegalAdviceRemoteDataSource>(
      () => LegalAdviceRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<OpenionsRemoteDataSource>(
      () => OpenionsRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<QuestionRemoteDataSource>(
      () => QuestionRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<RequestsRemoteDataSource>(
      () => RequestsRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<ComplaintsRemoteDataSource>(
      () => ComplaintsRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<LangLocalDataResource>(
      () => LangLocalDataResourceImpl(sharedPreferences: sl()));

  //! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => dio.Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
