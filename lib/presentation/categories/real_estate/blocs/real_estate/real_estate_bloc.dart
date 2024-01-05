import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/categories/usecases/real_estate/add_real_estate_use_case.dart';
import 'package:netzoon/domain/categories/usecases/real_estate/get_all_real_estates_use_case.dart';
import 'package:netzoon/domain/categories/usecases/real_estate/get_company_real_estates_use_case.dart';
import 'package:netzoon/domain/categories/usecases/real_estate/get_real_estate_by_id_use_case.dart';
import 'package:netzoon/domain/categories/usecases/real_estate/get_real_estate_companies_use_case.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../domain/auth/entities/user.dart';
import '../../../../../domain/auth/entities/user_info.dart';
import '../../../../../domain/categories/entities/real_estate/real_estate.dart';

part 'real_estate_event.dart';
part 'real_estate_state.dart';

class RealEstateBloc extends Bloc<RealEstateEvent, RealEstateState> {
  final GetAllRealEstatesUseCase getAllRealEstatesUseCase;
  final GetRealEstateCompaniesUseCase getRealEstateCompaniesUseCase;
  final GetCompanyRealEstatesUseCase getCompanyRealEstatesUseCase;
  final GetSignedInUserUseCase getSignedInUserUseCase;
  final AddRealEstateUseCase addRealEstateUseCase;
  final GetCountryUseCase getCountryUseCase;
  final GetRealEstateByIdUseCase getRealEstateByIdUseCase;
  RealEstateBloc({
    required this.getAllRealEstatesUseCase,
    required this.getRealEstateCompaniesUseCase,
    required this.getCompanyRealEstatesUseCase,
    required this.getSignedInUserUseCase,
    required this.addRealEstateUseCase,
    required this.getCountryUseCase,
    required this.getRealEstateByIdUseCase,
  }) : super(RealEstateInitial()) {
    on<GetAllRealEstatesEvent>((event, emit) async {
      emit(GetRealEstateInProgress());

      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');

      final realEstates = await getAllRealEstatesUseCase(country);

      emit(
        realEstates.fold(
          (failure) =>
              GetRealEstateFailure(message: mapFailureToString(failure)),
          (realEstates) => GetAllRealEstatesSuccess(realEstates: realEstates),
        ),
      );
    });
    on<GetRealEstateCompaniesEvent>((event, emit) async {
      emit(GetRealEstateInProgress());

      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');
      final companies = await getRealEstateCompaniesUseCase(country);

      emit(
        companies.fold(
          (failure) =>
              GetRealEstateFailure(message: mapFailureToString(failure)),
          (companies) => GetRealEstateCompaniesSuccess(companies: companies),
        ),
      );
    });
    on<GetCompanyRealEstatesEvent>((event, emit) async {
      emit(GetRealEstateInProgress());
      final realEstates = await getCompanyRealEstatesUseCase(event.id);
      emit(
        realEstates.fold(
          (failure) =>
              GetRealEstateFailure(message: mapFailureToString(failure)),
          (realEstates) =>
              GetCompanyRealEstatesSuccess(realEstates: realEstates),
        ),
      );
    });
    on<GetRealEstateByIdEvent>((event, emit) async {
      emit(GetRealEstateInProgress());
      final result = await getRealEstateByIdUseCase(event.id);
      emit(result.fold(
          (l) => GetRealEstateFailure(message: mapFailureToString(l)),
          (r) => GetRealEstateByIdSuccess(realEstate: r)));
    });
    on<AddRealEstateEvent>((event, emit) async {
      emit(AddRealEstateInProgress());
      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);

      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');

      final realEstate = await addRealEstateUseCase(AddRealEstateParams(
        createdBy: user.userInfo.id,
        title: event.title,
        image: event.image,
        description: event.description,
        price: event.price,
        area: event.area,
        location: event.location,
        bedrooms: event.bedrooms,
        bathrooms: event.bathrooms,
        amenities: event.amenities,
        realestateimages: event.realestateimages,
        country: country,
        type: event.type,
        category: event.category,
        forWhat: event.forWhat,
        furnishing: event.furnishing,
      ));

      emit(
        realEstate.fold(
          (failure) =>
              AddRealEstateFailure(message: mapFailureToString(failure)),
          (realEstate) => AddRealEstateSuccess(realEstate: realEstate),
        ),
      );
    });
  }
}
