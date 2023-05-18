import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:netzoon/domain/departments/usecases/add_product_use_case.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final AddProductUseCase addProductUseCase;
  AddProductBloc({required this.addProductUseCase})
      : super(AddProductInitial()) {
    on<AddProductRequestedEvent>((event, emit) async {
      emit(AddProductInProgress());
      final Response response = await _uploadFile(
        departmentName: event.departmentName,
        categoryName: event.categoryName,
        name: event.name,
        description: event.description,
        price: event.price,
        image: event.image,
      );
      if (response.statusCode == 201) {
        emit(AddProductSuccess(product: response.data));
      } else {
        emit(const AddProductFailure(message: 'failed to add product'));
      }
      // print('1');
      // final failureOrProduct = await addProductUseCase(AddProductParams(
      //   departmentName: event.departmentName,
      //   categoryName: event.categoryName,
      //   name: event.name,
      //   description: event.description,
      //   price: event.price,
      //   guarantee: event.guarantee,
      //   images: event.images,
      //   madeIn: event.madeIn,
      //   property: event.property,
      //   videoUrl: event.videoUrl,
      //   image: event.image,
      // ));
      // print(failureOrProduct);

      // emit(
      //   failureOrProduct.fold(
      //     (failure) => AddProductFailure(message: mapFailureToString(failure)),
      //     (product) {
      //       print(product);
      //       return AddProductSuccess(product: product);
      //     },
      //   ),
      // );
      // print('111');
    });
  }
}

Future<Response<dynamic>> _uploadFile({
  required String departmentName,
  required String categoryName,
  required String name,
  required String description,
  required int price,
  required File image,
}) async {
  try {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'departmentName': departmentName,
      'categoryName': categoryName,
      'name': name,
      'description': description,
      'price': price,
      'image': await MultipartFile.fromFile(image.path,
          filename: 'image.jpg', contentType: MediaType('image', 'jpeg')),
    });

    Response response = await dio
        .post('http://10.0.2.2:5000/departments/addProduct', data: formData);
    // Handle the response as needed

    return response;
  } catch (e) {
    rethrow;
  }
}
