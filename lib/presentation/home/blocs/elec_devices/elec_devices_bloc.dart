import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories.dart';
import 'package:netzoon/domain/departments/usecases/get_categories_by_departments_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_category_products_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/core/usecase/usecase.dart';
import '../../../../domain/departments/usecases/get_all_products_use_case.dart';

part 'elec_devices_event.dart';
part 'elec_devices_state.dart';

class ElecDevicesBloc extends Bloc<ElecDevicesEvent, ElecDevicesState> {
  final GetCategoriesByDepartmentUsecase getCategoriesByDepartmentUsecase;
  final GetCategoryProductsUseCase getCategoryProductsUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;
  ElecDevicesBloc({
    required this.getAllProductsUseCase,
    required this.getCategoriesByDepartmentUsecase,
    required this.getCategoryProductsUseCase,
  }) : super(ElecDevicesInitial()) {
    on<GetElcDevicesEvent>((event, emit) async {
      emit(ElecDevicesInProgress());
      final failureOrCategories = await getCategoriesByDepartmentUsecase(
        DepartmentsCatParams(department: event.department),
      );
      emit(
        failureOrCategories.fold((failure) {
          // print(failure);
          return ElecDevicesFailure(message: mapFailureToString(failure));
        }, (elecDevices) {
          // print(elecDevices);
          return ElecDevicesSuccess(elecDevices: elecDevices.departmentsCat);
        }),
      );
    });
    on<GetElcCategoryProductsEvent>((event, emit) async {
      emit(ElecDevicesInProgress());
      final failureOrProducts = await getCategoryProductsUseCase(
          CategoryProductsParams(
              department: event.department, category: event.category));
      emit(
        failureOrProducts.fold(
          (failure) {
            return ElecDevicesFailure(message: mapFailureToString(failure));
          },
          (categoryProducts) {
            return ElecCategoryProductSuccess(
                department: categoryProducts.department,
                category: categoryProducts.category,
                categoryProducts: categoryProducts.products);
          },
        ),
      );
    });
    on<GetAllProductsEvent>((event, emit) async {
      emit(ElecDevicesInProgress());
      final products = await getAllProductsUseCase(NoParams());

      emit(
        products.fold(
            (failure) =>
                ElecDevicesFailure(message: mapFailureToString(failure)),
            (categoryProducts) {
          return ElecCategoryProductSuccess(categoryProducts: categoryProducts);
        }),
      );
    });
  }
}
