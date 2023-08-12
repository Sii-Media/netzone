import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/add_vehicle_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_cars_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_new_planes_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_planes_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_used_planes_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_cars_companies_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_company_vehicles_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_latest_car_by_creator_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_planes_companies_use_case.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';

import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../domain/auth/entities/user.dart';
import '../../../../../domain/auth/entities/user_info.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetAllCarsUseCase getAllCarsUseCase;
  final GetLatestCarByCreatorUseCase getLatestCarByCreatorUseCase;
  final GetAllUsedPlanesUseCase getAllUsedPlanesUseCase;
  final GetAllNewPlanesUseCase getAllNewPlanesUseCase;
  final GetCarsCompaniesUseCase getCarsCompaniesUseCase;
  final GetPlanesCompaniesUseCase getPlanesCompaniesUseCase;
  final GetCompanyVehiclesUseCase getCompanyVehiclesUseCase;
  final GetAllPlanesUseCase getAllPlanesUseCase;
  final AddVehicleUseCase addVehicleUseCase;
  final GetSignedInUserUseCase getSignedInUserUseCase;
  final GetCountryUseCase getCountryUseCase;
  VehicleBloc({
    required this.getAllCarsUseCase,
    required this.getLatestCarByCreatorUseCase,
    required this.getAllUsedPlanesUseCase,
    required this.getAllNewPlanesUseCase,
    required this.getCarsCompaniesUseCase,
    required this.getPlanesCompaniesUseCase,
    required this.getCompanyVehiclesUseCase,
    required this.getAllPlanesUseCase,
    required this.addVehicleUseCase,
    required this.getSignedInUserUseCase,
    required this.getCountryUseCase,
  }) : super(VehicleInitial()) {
    on<GetAllCarsEvent>((event, emit) async {
      emit(VehicleInProgress());
      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');
      final failureOrCars = await getAllCarsUseCase(GetAllCarsParams(
        country: country,
        creator: event.creator,
        priceMax: event.priceMax,
        priceMin: event.priceMin,
        type: event.type,
      ));

      emit(
        failureOrCars.fold(
          (failure) => VehicleFailure(message: mapFailureToString(failure)),
          (cars) => VehicleSuccess(vehilces: cars.vehicle),
        ),
      );
    });
    on<GetLatestCarByCreatorEvent>((event, emit) async {
      emit(VehicleInProgress());
      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');
      final failureOrCars = await getLatestCarByCreatorUseCase(country);

      emit(
        failureOrCars.fold(
          (failure) => VehicleFailure(message: mapFailureToString(failure)),
          (cars) => VehicleSuccess(vehilces: cars.vehicle),
        ),
      );
    });
    on<GetAllPlanesEvent>((event, emit) async {
      emit(VehicleInProgress());
      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');
      final failureOrPlanes = await getAllPlanesUseCase(GetAllPlanesParams(
        country: country,
        creator: event.creator,
        priceMax: event.priceMax,
        priceMin: event.priceMin,
        type: event.type,
      ));

      emit(
        failureOrPlanes.fold(
          (failure) => VehicleFailure(message: mapFailureToString(failure)),
          (planes) => VehicleSuccess(vehilces: planes.vehicle),
        ),
      );
    });
    on<GetAllUsedPlanesEvent>((event, emit) async {
      emit(VehicleInProgress());
      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');
      final failureOrPlanes = await getAllUsedPlanesUseCase(country);

      emit(
        failureOrPlanes.fold(
          (failure) => VehicleFailure(message: mapFailureToString(failure)),
          (planes) => VehicleSuccess(vehilces: planes.vehicle),
        ),
      );
    });
    on<GetAllNewPlanesEvent>((event, emit) async {
      emit(VehicleInProgress());
      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');
      final failureOrPlanes = await getAllNewPlanesUseCase(country);

      emit(
        failureOrPlanes.fold(
          (failure) => VehicleFailure(message: mapFailureToString(failure)),
          (planes) => VehicleSuccess(vehilces: planes.vehicle),
        ),
      );
    });
    on<GetCarsCompaniesEvent>((event, emit) async {
      emit(VehicleInProgress());

      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');

      final failureOrcarsCompanies = await getCarsCompaniesUseCase(country);

      emit(
        failureOrcarsCompanies.fold(
          (failure) => VehicleFailure(message: mapFailureToString(failure)),
          (vehiclesCompanies) =>
              VehiclesCompaniesSuccess(vehiclesCompanies: vehiclesCompanies),
        ),
      );
    });

    on<GetPlanesCompaniesEvent>((event, emit) async {
      emit(VehicleInProgress());
      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');

      final failureOrcarsCompanies = await getPlanesCompaniesUseCase(country);

      emit(
        failureOrcarsCompanies.fold(
          (failure) => VehicleFailure(message: mapFailureToString(failure)),
          (vehiclesCompanies) =>
              VehiclesCompaniesSuccess(vehiclesCompanies: vehiclesCompanies),
        ),
      );
    });
    on<GetCompanyVehiclesEvent>((event, emit) async {
      emit(VehicleInProgress());
      final failureOrVehicles = await getCompanyVehiclesUseCase(
          GetCompanyVehiclesParams(type: event.type, id: event.id));

      emit(
        failureOrVehicles.fold(
          (failure) => VehicleFailure(message: mapFailureToString(failure)),
          (companyVehicles) =>
              GetCompanyVehiclesSuccess(companyVehicles: companyVehicles),
        ),
      );
    });
    on<AddVehicleEvent>((event, emit) async {
      emit(AddVehicleInProgress());

      final result = await getSignedInUserUseCase.call(NoParams());
      late User? user;
      result.fold((l) => null, (r) => user = r);

      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');

      final response = await addVehicleUseCase(AddVehicleParams(
        name: event.name,
        description: event.description,
        price: event.price,
        kilometers: event.kilometers,
        year: event.year,
        location: event.location,
        type: event.type,
        category: event.category,
        creator: user?.userInfo.id ?? '',
        image: event.image,
        carimages: event.carimages,
        video: event.video,
        country: country,
        contactNumber: event.contactNumber,
        exteriorColor: event.exteriorColor,
        interiorColor: event.interiorColor,
        bodyCondition: event.bodyCondition,
        bodyType: event.bodyType,
        doors: event.doors,
        extras: event.extras,
        fuelType: event.fuelType,
        guarantee: event.guarantee,
        horsepower: event.horsepower,
        mechanicalCondition: event.mechanicalCondition,
        numofCylinders: event.numofCylinders,
        seatingCapacity: event.seatingCapacity,
        steeringSide: event.steeringSide,
        technicalFeatures: event.technicalFeatures,
        transmissionType: event.transmissionType,
        forWhat: event.forWhat,
      ));
      emit(
        response.fold(
          (failure) => AddVehicleFailure(message: mapFailureToString(failure)),
          (message) => AddVehicleSuccess(message: message),
        ),
      );
    });
  }
}
