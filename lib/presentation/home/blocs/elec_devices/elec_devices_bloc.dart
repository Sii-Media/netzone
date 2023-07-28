import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories.dart';
import 'package:netzoon/domain/departments/usecases/edit_product_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_categories_by_departments_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_category_products_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_product_by_id_use_case.dart';
import 'package:netzoon/domain/departments/usecases/rate_product_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../domain/core/usecase/usecase.dart';
import '../../../../domain/departments/usecases/delete_product_use_case.dart';
import '../../../../domain/departments/usecases/get_all_products_use_case.dart';

part 'elec_devices_event.dart';
part 'elec_devices_state.dart';

class ElecDevicesBloc extends Bloc<ElecDevicesEvent, ElecDevicesState> {
  final GetCategoriesByDepartmentUsecase getCategoriesByDepartmentUsecase;
  final GetCategoryProductsUseCase getCategoryProductsUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final EditProductUseCase editProductUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;
  final GetCountryUseCase getCountryUseCase;
  final RateProductUseCase rateProductUseCase;
  final GetSignedInUserUseCase getSignedInUserUseCase;

  List<CategoryProducts> filteredProducts = [];
  ElecDevicesBloc({
    required this.deleteProductUseCase,
    required this.getAllProductsUseCase,
    required this.getCategoriesByDepartmentUsecase,
    required this.getCategoryProductsUseCase,
    required this.editProductUseCase,
    required this.getProductByIdUseCase,
    required this.getCountryUseCase,
    required this.rateProductUseCase,
    required this.getSignedInUserUseCase,
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
      late String country;
      final result = await getCountryUseCase(NoParams());
      result.fold((l) => null, (r) => country = r ?? 'AE');
      final failureOrProducts =
          await getCategoryProductsUseCase(CategoryProductsParams(
        country: country,
        department: event.department,
        category: event.category,
        priceMin: event.priceMin,
        priceMax: event.priceMax,
        owner: event.owner,
        condition: event.condition,
      ));
      filteredProducts = failureOrProducts.fold(
          (l) => [], (categoryProducts) => categoryProducts.products);
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
      late String country;
      final result = await getCountryUseCase(NoParams());
      result.fold((l) => null, (r) => country = r ?? 'AE');

      final products = await getAllProductsUseCase(country);

      emit(
        products.fold(
            (failure) =>
                ElecDevicesFailure(message: mapFailureToString(failure)),
            (categoryProducts) {
          return ElecCategoryProductSuccess(categoryProducts: categoryProducts);
        }),
      );
    });
    on<DeleteProductEvent>((event, emit) async {
      emit(DeleteProductInProgress());

      final result = await deleteProductUseCase(event.productId);

      emit(
        result.fold(
          (failure) =>
              DeleteProductFailure(message: mapFailureToString(failure)),
          (r) => DeleteProductSuccess(),
        ),
      );
    });
    on<EditProductEvent>((event, emit) async {
      emit(EditProductInProgress());

      final result = await editProductUseCase(EditProductParams(
        productId: event.productId,
        name: event.name,
        description: event.description,
        price: event.price,
        guarantee: event.guarantee,
        address: event.address,
        image: event.image,
        madeIn: event.madeIn,
        video: event.video,
      ));
      emit(
        result.fold(
          (failure) => EditProductFailure(message: mapFailureToString(failure)),
          (message) => EditProductSuccess(message: message),
        ),
      );
    });
    on<GetProductByIdEvent>((event, emit) async {
      emit(ElecDevicesInProgress());

      final product = await getProductByIdUseCase(event.productId);

      emit(
        product.fold(
          (failure) => ElecDevicesFailure(message: mapFailureToString(failure)),
          (product) => GetProductByIdSuccess(product: product),
        ),
      );
    });
    on<SearchProductsEvent>((event, emit) {
      // ignore: unused_local_variable
      final searchResults = filteredProducts
          .where((product) => product.name
              .toLowerCase()
              .contains(event.searchQuery.toLowerCase()))
          .toList();

      emit(ElecCategoryProductSuccess(categoryProducts: filteredProducts));
    });
    on<RateProductEvent>((event, emit) async {
      emit(RateProductInProgress());
      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      final rating = await rateProductUseCase(RateProductParams(
          id: event.id, rating: event.rating, userId: user.userInfo.id));

      emit(
        rating.fold(
          (failure) => RateProductFailure(message: mapFailureToString(failure)),
          (message) => RateProductSuccess(message: message),
        ),
      );
    });
  }
}
