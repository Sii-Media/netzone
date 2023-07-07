import 'package:dio/dio.dart' as dio;
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/local/auth/auth_local_data_source.dart';
import 'package:netzoon/data/datasource/local/favorite/favorite_local_data_source.dart';
import 'package:netzoon/data/datasource/local/lang/lang_local_data_resource.dart';
import 'package:netzoon/data/datasource/remote/advertisements/ads_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/datasource/remote/complaints/complaints_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/customs/customs_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/deals/deals_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/departments/departments_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/factories/factories_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/favorites/favorite_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/freezones/freezone_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/govermental/govermental_data_source.dart';
import 'package:netzoon/data/datasource/remote/legal_advice/legal_advice_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/local_company/local_company_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/news/news_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/notifications/notification_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/openions/openion_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/questions/question_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/requests/requests_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/send_email/send_email_remote_data_sourse.dart';
import 'package:netzoon/data/datasource/remote/tenders/tenders_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/users/users_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/vehicles/vehicle_remote_data_source.dart';
import 'package:netzoon/data/repositories/advertisments/advertisment_repository_impl.dart';
import 'package:netzoon/data/repositories/auth_repository_impl.dart';
import 'package:netzoon/data/repositories/complaints/complaints_repository_impl.dart';
import 'package:netzoon/data/repositories/customs/customs_repository_impl.dart';
import 'package:netzoon/data/repositories/deals/deals_repository_impl.dart';
import 'package:netzoon/data/repositories/departments/departments_repository_impl.dart';
import 'package:netzoon/data/repositories/factories/factories_repository_impl.dart';
import 'package:netzoon/data/repositories/favorites/favorite_repository_impl.dart';
import 'package:netzoon/data/repositories/freezones/freezone_repository_impl.dart';
import 'package:netzoon/data/repositories/govermental/govermental_repository_impl.dart';
import 'package:netzoon/data/repositories/lang/lang_repository_impl.dart';
import 'package:netzoon/data/repositories/legal_advice/legal_advice_repository_impl.dart';
import 'package:netzoon/data/repositories/local_company/local_company_repository_impl.dart';
import 'package:netzoon/data/repositories/news/news_repositories_impl.dart';
import 'package:netzoon/data/repositories/notifications/notifications_repo_impl.dart';
import 'package:netzoon/data/repositories/openions/openion_repository_impl.dart';
import 'package:netzoon/data/repositories/questions/question_repository_impl.dart';
import 'package:netzoon/data/repositories/requests/requests_repository_impl.dart';
import 'package:netzoon/data/repositories/send_emails/send_email_repository_impl.dart';
import 'package:netzoon/data/repositories/tenders/tenders_repository_impl.dart';
import 'package:netzoon/data/repositories/users/users_repository_impl.dart';
import 'package:netzoon/data/repositories/vehicles/vehicle_repository_impl.dart';
import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/advertisements/usercases/add_ads_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/get_ads_by_type_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/get_advertisements_usecase.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/auth/usecases/add_account_to_user_use_case.dart';
import 'package:netzoon/domain/auth/usecases/change_account_use_case.dart';
import 'package:netzoon/domain/auth/usecases/change_password_use_case.dart';
import 'package:netzoon/domain/auth/usecases/edit_profile_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_first_time_logged_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_otpcode_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_user_accounts_use_case.dart';
import 'package:netzoon/domain/auth/usecases/logout_use_case.dart';
import 'package:netzoon/domain/auth/usecases/set_first_time_logged_use_case.dart';
import 'package:netzoon/domain/auth/usecases/sign_in_use_case.dart';
import 'package:netzoon/domain/auth/usecases/sign_up_use_case.dart';
import 'package:netzoon/domain/auth/usecases/verify_otp_code_use_case.dart';
import 'package:netzoon/domain/categories/repositories/customs_repository.dart';
import 'package:netzoon/domain/categories/repositories/factories_repository.dart';
import 'package:netzoon/domain/categories/repositories/freezone_repository.dart';
import 'package:netzoon/domain/categories/repositories/govermental_repository.dart';
import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/categories/repositories/users_repository.dart';
import 'package:netzoon/domain/categories/repositories/vehicle_repository.dart';
import 'package:netzoon/domain/categories/usecases/customs/get_all_customs_use_case.dart';
import 'package:netzoon/domain/categories/usecases/customs/get_custom_companies_use_case.dart';
import 'package:netzoon/domain/categories/usecases/factories/get_all_factories_use_case.dart';
import 'package:netzoon/domain/categories/usecases/factories/get_factory_companies_use_case.dart';
import 'package:netzoon/domain/categories/usecases/freezone/get_freezone_places_by_id_use_case.dart';
import 'package:netzoon/domain/categories/usecases/freezone/get_freezone_places_use_case.dart';
import 'package:netzoon/domain/categories/usecases/governmental/get_all_governmental_use_case.dart';
import 'package:netzoon/domain/categories/usecases/governmental/get_govermental_companies_use_case.dart';
import 'package:netzoon/domain/categories/usecases/local_company/get_all_local_companies_use_case.dart';
import 'package:netzoon/domain/categories/usecases/local_company/get_company_products_use_case.dart';
import 'package:netzoon/domain/categories/usecases/local_company/get_local_companies_use_case.dart';
import 'package:netzoon/domain/categories/usecases/users/get_users_list_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_cars_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_new_planes_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_used_planes_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_cars_companies_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_company_vehicles_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_planes_companies_use_case.dart';

import 'package:netzoon/domain/complaints/repositories/complaints_repository.dart';
import 'package:netzoon/domain/complaints/usecases/add_complaints_usecase.dart';
import 'package:netzoon/domain/complaints/usecases/get_complaints_usecase.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';
import 'package:netzoon/domain/deals/usecases/add_deal_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_all_deals_items_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_deals_cat_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_deals_items_by_cat_use_case.dart';
import 'package:netzoon/domain/departments/repositories/departments_repository.dart';
import 'package:netzoon/domain/departments/usecases/add_product_use_case.dart';
import 'package:netzoon/domain/departments/usecases/add_to_selected_products_use_case.dart';
import 'package:netzoon/domain/departments/usecases/delete_from_selected_products_use_case.dart';
import 'package:netzoon/domain/departments/usecases/delete_product_use_case.dart';
import 'package:netzoon/domain/departments/usecases/edit_product_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_categories_by_departments_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_category_products_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_selected_products_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_user_products_use_case.dart';
import 'package:netzoon/domain/favorites/repositories/favorite_repository.dart';
import 'package:netzoon/domain/favorites/usecases/clear_favorite_use_case.dart';
import 'package:netzoon/domain/favorites/usecases/get_favorite_items_use_case.dart';
import 'package:netzoon/domain/favorites/usecases/remove_from_favorite_use_case.dart';
import 'package:netzoon/domain/lang/repositories/lang_repository.dart';
import 'package:netzoon/domain/lang/usecases/change_language.dart';
import 'package:netzoon/domain/lang/usecases/get_init_language.dart';
import 'package:netzoon/domain/legal_advice/repositories/legal_advice_repository.dart';
import 'package:netzoon/domain/legal_advice/usecases/get_legal_advices_use_case.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';
import 'package:netzoon/domain/news/usecases/add_comment_use_case.dart';
import 'package:netzoon/domain/news/usecases/add_like_use_case.dart';
import 'package:netzoon/domain/news/usecases/add_news_use_case.dart';
import 'package:netzoon/domain/news/usecases/get_all_news_usecase.dart';
import 'package:netzoon/domain/news/usecases/get_comments_use_case.dart';
import 'package:netzoon/domain/notifications/repositories/notification_repository.dart';
import 'package:netzoon/domain/notifications/use_cases/get_all_notifications_use_case.dart';
import 'package:netzoon/domain/openions/repositories/openion_repository.dart';
import 'package:netzoon/domain/openions/usecases/add_openion_use_case.dart';
import 'package:netzoon/domain/questions/repositories/question_repository.dart';
import 'package:netzoon/domain/questions/usecases/add_question_use_case.dart';
import 'package:netzoon/domain/requests/repositories/requests_repository.dart';
import 'package:netzoon/domain/requests/usecases/add_request_use_case.dart';
import 'package:netzoon/domain/send_emails/repositories/send_email_repository.dart';
import 'package:netzoon/domain/tenders/repositories/tenders_repository.dart';
import 'package:netzoon/domain/tenders/usecases/get_all_tenders_items.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_cat_use_case.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_items_by_min.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_items_by_max.dart';
import 'package:netzoon/presentation/add_items/blocs/add_product/add_product_bloc.dart';
import 'package:netzoon/presentation/advertising/blocs/add_ads/add_ads_bloc.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/change_password/change_password_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/get_otp_code/get_otp_code_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/sign_in/sign_in_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/categories/cars/blocs/cars_bloc/cars_bloc.dart';
import 'package:netzoon/presentation/categories/customs_screen/customs_bloc/customs_bloc.dart';
import 'package:netzoon/presentation/categories/factories/blocs/factories_bloc/factories_bloc.dart';
import 'package:netzoon/presentation/categories/free_zoon/blocs/freezone_bloc/freezone_bloc.dart';
import 'package:netzoon/presentation/categories/governmental/govermental_bloc/govermental_bloc.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/categories/plans/blocs/planes/planes_bloc.dart';
import 'package:netzoon/presentation/categories/users/blocs/users_bloc/users_bloc.dart';
import 'package:netzoon/presentation/categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/add_complaint/add_complaint_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/add_openion/add_openion_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/add_question/add_question_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/add_request/add_request_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/get_complaints/get_complaint_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/send_email/send_email_bloc.dart';
import 'package:netzoon/presentation/deals/blocs/dealsItems/deals_items_bloc.dart';
import 'package:netzoon/presentation/deals/blocs/deals_category/deals_categoty_bloc.dart';
import 'package:netzoon/presentation/favorites/favorite_blocs/favorites_bloc.dart';
import 'package:netzoon/presentation/home/blocs/elec_devices/elec_devices_bloc.dart';
import 'package:netzoon/presentation/language_screen/blocs/language_bloc/language_bloc.dart';
import 'package:netzoon/presentation/legal_advice/blocs/legal_advice/legal_advice_bloc.dart';
import 'package:netzoon/presentation/news/blocs/add_news/add_news_bloc.dart';
import 'package:netzoon/presentation/news/blocs/comments/comments_bloc.dart';
import 'package:netzoon/presentation/news/blocs/news/news_bloc.dart';
import 'package:netzoon/presentation/notifications/blocs/notifications/notifications_bloc.dart';
import 'package:netzoon/presentation/profile/blocs/add_account/add_account_bloc.dart';
import 'package:netzoon/presentation/profile/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:netzoon/presentation/profile/blocs/get_user/get_user_bloc.dart';
import 'package:netzoon/presentation/tenders/blocs/tendersCategory/tender_cat_bloc.dart';
import 'package:netzoon/presentation/tenders/blocs/tendersItem/tenders_item_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/advertisements/usercases/get_ads_by_id_use_case.dart';
import 'domain/auth/usecases/get_user_by_id_use_case.dart';
import 'domain/deals/usecases/get_deal_by_id_use_case.dart';
import 'domain/departments/usecases/get_all_products_use_case.dart';
import 'domain/departments/usecases/get_product_by_id_use_case.dart';
import 'domain/favorites/usecases/add_item_to_favorite_use_case.dart';
import 'domain/news/usecases/get_news_by_id_use_case.dart';
import 'domain/notifications/use_cases/send_notification_use_case.dart';
import 'domain/send_emails/use_cases/send_email_use_case.dart';
import 'domain/tenders/usecases/add_tender_use_case.dart';

const String baseUrl = 'https://net-zoon.onrender.com';
final sl = GetIt.instance;

Future<void> init() async {
  //! Bloc
  sl.registerFactory(() => SignUpBloc(signUpUseCase: sl()));
  sl.registerFactory(() => SignInBloc(signInUseCase: sl()));
  sl.registerFactory(() => AdsBlocBloc(
      getAdvertismentsUseCase: sl(),
      getAdsByTypeUseCase: sl(),
      getAdsByIdUseCase: sl()));
  sl.registerFactory(() => NewsBloc(
        getAllNewsUseCase: sl(),
        getSignedInUser: sl(),
        toggleOnLikeUseCase: sl(),
        getNewsByIdUseCase: sl(),
      ));
  sl.registerFactory(
      () => AddNewsBloc(addNewsUseCase: sl(), getSignedInUser: sl()));
  sl.registerFactory(() => TenderCatBloc(getTendersCategoriesUseCase: sl()));
  sl.registerFactory(() => TendersItemBloc(
        getTendersItemByMin: sl(),
        getTendersItemByMax: sl(),
        getTendersItem: sl(),
        addTenderUseCase: sl(),
      ));

  sl.registerFactory(() => DealsCategotyBloc(getDealsCategoriesUseCase: sl()));
  sl.registerFactory(() => DealsItemsBloc(
        getDealsItemsByCat: sl(),
        getDealsItemUsecase: sl(),
        addDealUseCase: sl(),
        getDealByIdUseCase: sl(),
      ));

  sl.registerFactory(() => ElecDevicesBloc(
        getCategoriesByDepartmentUsecase: sl(),
        getCategoryProductsUseCase: sl(),
        getAllProductsUseCase: sl(),
        deleteProductUseCase: sl(),
        editProductUseCase: sl(),
        getProductByIdUseCase: sl(),
      ));

  sl.registerFactory(() => AddProductBloc(
        addProductUseCase: sl(),
        getSignedInUser: sl(),
      ));
  sl.registerFactory(() => CartBlocBloc());

  sl.registerFactory(() => LegalAdviceBloc(getLegalAdvicesUseCase: sl()));

  sl.registerFactory(() => AddOpenionBloc(addOpenionUseCase: sl()));

  sl.registerFactory(() => AddQuestionBloc(addQuestionUseCase: sl()));

  sl.registerFactory(() => AddRequestBloc(addRequestUseCase: sl()));

  sl.registerFactory(() => GetComplaintBloc(getComplaintsUseCase: sl()));
  sl.registerFactory(() => AddComplaintBloc(addComplaintsUseCase: sl()));

  sl.registerFactory(() => AddAdsBloc(
        addAdvertisementUseCase: sl(),
        getSignedInUser: sl(),
      ));

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

  sl.registerFactory(() => CarsBloc(getAllCarsUseCase: sl()));
  sl.registerFactory(() =>
      PlanesBloc(getAllUsedPlanesUseCase: sl(), getAllNewPlanesUseCase: sl()));

  sl.registerFactory(() => VehicleBloc(
        getAllCarsUseCase: sl(),
        getAllUsedPlanesUseCase: sl(),
        getAllNewPlanesUseCase: sl(),
        getCarsCompaniesUseCase: sl(),
        getPlanesCompaniesUseCase: sl(),
        getCompanyVehiclesUseCase: sl(),
      ));

  sl.registerFactory(() => FreezoneBloc(
      getFreeZonePlacesUseCase: sl(), getFreeZonePlacesByIdUseCase: sl()));

  sl.registerFactory(() => FactoriesBloc(
      getAllFactoriesUseCase: sl(), getFactoryCompaniesUseCase: sl()));

  sl.registerFactory(() => LocalCompanyBloc(
        getAllLocalCompaniesUseCase: sl(),
        getCompanyProductsUseCase: sl(),
        getLocalCompaniesUseCase: sl(),
        getSignedInUser: sl(),
        getUserProductsUseCase: sl(),
      ));

  sl.registerFactory(() => GovermentalBloc(
        getAllGovermentalUseCase: sl(),
        getGovermentalCompaniesUseCase: sl(),
      ));

  sl.registerFactory(() =>
      CustomsBloc(getAllCustomsUseCase: sl(), getCustomCompaniesUseCase: sl()));

  sl.registerFactory(() => FavoritesBloc(
      getFavoriteItemsUseCase: sl(),
      additemToFavoriteUseCase: sl(),
      removeItemFromFavoriteUseCase: sl(),
      clearFavoritesUseCase: sl(),
      getSignedInUser: sl(),
      favoritesLocalDataSource: sl()));

  sl.registerFactory(() => SendEmailBloc(sendEmailUseCase: sl()));

  sl.registerFactory(() =>
      CommentsBloc(sl(), getCommentsUseCase: sl(), addCommentUseCase: sl()));

  sl.registerFactory(
      () => EditProfileBloc(editProfileUseCase: sl(), getSignedInUser: sl()));

  sl.registerFactory(() => GetUserBloc(
        getUserByIdUseCase: sl(),
        getSignedInUserUseCase: sl(),
        getUserProductsUseCase: sl(),
        getSelectedProductsUseCase: sl(),
        addToSelectedProductsUseCase: sl(),
        deleteFromSelectedProductsUseCase: sl(),
      ));

  sl.registerFactory(() => ChangePasswordBloc(
      changePasswordUseCase: sl(), getSignedInUserUseCase: sl()));

  sl.registerFactory(() => AddAccountBloc(
        addAccountUseCase: sl(),
        getSignedInUserUseCase: sl(),
        getUserAccountsUseCase: sl(),
        logoutUseCase: sl(),
        changeAccountUseCase: sl(),
      ));

  sl.registerFactory(() => NotificationsBloc(
      getAllNotificationsUseCase: sl(),
      sendNotificationUseCase: sl(),
      getSignedInUser: sl()));

  sl.registerFactory(
      () => UsersBloc(getSignedInUser: sl(), getUsersListUseCase: sl()));

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

  sl.registerLazySingleton(() => GetAllCarsUseCase(vehicleRepository: sl()));

  sl.registerLazySingleton(
      () => GetAllUsedPlanesUseCase(vehicleRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllNewPlanesUseCase(vehicleRepository: sl()));

  sl.registerLazySingleton(
      () => GetFreeZonePlacesUseCase(freeZoneRepository: sl()));
  sl.registerLazySingleton(
      () => GetFreeZonePlacesByIdUseCase(freeZoneRepository: sl()));

  sl.registerLazySingleton(
      () => GetAllFactoriesUseCase(factoriesRepository: sl()));

  sl.registerLazySingleton(
      () => GetFactoryCompaniesUseCase(factoriesRepository: sl()));

  sl.registerLazySingleton(
      () => GetAllLocalCompaniesUseCase(localCompanyRepository: sl()));

  sl.registerLazySingleton(
      () => GetCompanyProductsUseCase(localCompanyRepository: sl()));

  sl.registerLazySingleton(() => GetAllCustomsUseCase(customsRepository: sl()));
  sl.registerLazySingleton(
      () => GetCustomCompaniesUseCase(customsRepository: sl()));

  sl.registerLazySingleton(
      () => GetAllGovermentalUseCase(govermentalRepository: sl()));

  sl.registerLazySingleton(
      () => GetGovermentalCompaniesUseCase(govermentalRepository: sl()));

  sl.registerLazySingleton(
      () => GetFavoriteItemsUseCase(favoriteRepository: sl()));

  sl.registerLazySingleton(
      () => AdditemToFavoriteUseCase(favoriteRepository: sl()));

  sl.registerLazySingleton(
      () => RemoveItemFromFavoriteUseCase(favoriteRepository: sl()));

  sl.registerLazySingleton(
      () => ClearFavoritesUseCase(favoriteRepository: sl()));

  sl.registerLazySingleton(() => SendEmailUseCase(sendEmailRepository: sl()));

  sl.registerLazySingleton(() => GetCommentsUseCase(newsRepository: sl()));

  sl.registerLazySingleton(() => AddCommentUseCase(newsRepository: sl()));

  sl.registerLazySingleton(() => ToggleOnLikeUseCase(newsRepository: sl()));

  sl.registerLazySingleton(() => EditProfileUseCase(authRepository: sl()));

  sl.registerLazySingleton(() => GetUserByIdUseCase(authRepository: sl()));

  sl.registerLazySingleton(
      () => GetAllProductsUseCase(departmentRepository: sl()));

  sl.registerLazySingleton(() => AddDealUseCase(dealsRepository: sl()));

  sl.registerLazySingleton(
      () => GetCarsCompaniesUseCase(vehicleRepository: sl()));
  sl.registerLazySingleton(
      () => GetPlanesCompaniesUseCase(vehicleRepository: sl()));

  sl.registerLazySingleton(
      () => GetCompanyVehiclesUseCase(vehicleRepository: sl()));

  sl.registerLazySingleton(() => ChangePasswordUseCase(authRepository: sl()));

  sl.registerLazySingleton(
      () => GetUserProductsUseCase(departmentRepository: sl()));

  sl.registerLazySingleton(() => AddTenderUseCase(tenderRepository: sl()));

  sl.registerLazySingleton(() => AddAccountUseCase(authRepository: sl()));

  sl.registerLazySingleton(() => GetUserAccountsUseCase(authRepository: sl()));

  sl.registerLazySingleton(() => ChangeAccountUseCase(authRepository: sl()));

  sl.registerLazySingleton(
      () => DeleteProductUseCase(departmentRepository: sl()));

  sl.registerLazySingleton(
      () => EditProductUseCase(departmentRepository: sl()));

  sl.registerLazySingleton(
      () => GetAllNotificationsUseCase(notificationRepository: sl()));

  sl.registerLazySingleton(
      () => GetProductByIdUseCase(departmentRepository: sl()));

  sl.registerLazySingleton(
      () => GetAdsByIdUseCase(advertismentRepository: sl()));

  sl.registerLazySingleton(() => GetDealByIdUseCase(dealsRepository: sl()));

  sl.registerLazySingleton(() => GetNewsByIdUseCase(newsRepository: sl()));

  sl.registerLazySingleton(
      () => SendNotificationUseCase(notificationRepository: sl()));

  sl.registerLazySingleton(
      () => GetLocalCompaniesUseCase(localCompanyRepository: sl()));

  sl.registerLazySingleton(() => GetUsersListUseCase(usersRepository: sl()));

  sl.registerLazySingleton(
      () => GetSelectedProductsUseCase(departmentRepository: sl()));

  sl.registerLazySingleton(
      () => AddToSelectedProductsUseCase(departmentRepository: sl()));

  sl.registerLazySingleton(
      () => DeleteFromSelectedProductsUseCase(departmentRepository: sl()));

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

  sl.registerLazySingleton<VehicleRepository>(() =>
      VehicleRepositoryImpl(networkInfo: sl(), vehicleRemoteDataSource: sl()));

  sl.registerLazySingleton<FreeZoneRepository>(() => FreeZoneRepositoryImpl(
      freeZoneRemoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<FactoriesRepository>(() => FactoriesRepositoryImpl(
      networkInfo: sl(), factoriesRemoteDataSource: sl()));

  sl.registerLazySingleton<LocalCompanyRepository>(() =>
      LocalCompanyRepositoryImpl(
          localCompanyRemoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<CustomsRepository>(() =>
      CustomsRepositoryImpl(customsRemoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<GovermentalRepository>(() =>
      GovermentalRepositoryImpl(
          networkInfo: sl(), govermentalRemoteDataSource: sl()));

  sl.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl(
      networkInfo: sl(), favoriteremoteDataSource: sl()));

  sl.registerLazySingleton<SendEmailRepository>(() => SendEmailRepositoryImpl(
      networkInfo: sl(), sendEmailRemoteDataSource: sl()));

  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(
            notificationRemoteDataSource: sl(),
            networkInfo: sl(),
          ));

  sl.registerLazySingleton<UsersRepository>(
      () => UsersRepositoryImpl(networkInfo: sl(), userRemoteDataSource: sl()));

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

  sl.registerLazySingleton<VehicleRemoteDataSource>(
      () => VehicleRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<FreeZoneRemoteDataSource>(
      () => FreeZoneRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<FactoriesRemoteDataSource>(
      () => FactoriesRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<LocalCompanyRemoteDataSource>(
      () => LocalCompanyRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<CustomsRemoteDataSource>(
      () => CustomsRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<GovermentalRemoteDataSource>(
      () => GovermentalRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<FavoriteremoteDataSource>(
      () => FavoriteremoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton(() => FavoritesLocalDataSource());

  sl.registerLazySingleton<SendEmailRemoteDataSource>(
      () => SendEmailRemoteDataSourceImpl());

  sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  sl.registerLazySingleton<UsersRemoteDataSource>(
      () => UsersRemoteDataSourceImpl(sl(), baseUrl: baseUrl));

  //! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => dio.Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
