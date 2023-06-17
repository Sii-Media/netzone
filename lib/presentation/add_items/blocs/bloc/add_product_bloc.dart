import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:netzoon/domain/departments/usecases/add_product_use_case.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../domain/core/usecase/usecase.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final AddProductUseCase addProductUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  AddProductBloc({
    required this.addProductUseCase,
    required this.getSignedInUser,
  }) : super(AddProductInitial()) {
    on<AddProductRequestedEvent>((event, emit) async {
      emit(AddProductInProgress());
      final result = await getSignedInUser.call(NoParams());
      late User? user;
      result.fold((l) => null, (r) => user = r);
      final Response response = await _uploadFile(
        owner: user?.userInfo.username ?? '',
        departmentName: event.departmentName,
        categoryName: event.categoryName,
        name: event.name,
        description: event.description,
        price: event.price,
        image: event.image,
        video: event.video,
        guarantee: event.guarantee,
        madeIn: event.madeIn,
        year: event.year,
        address: event.address,
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

// Future<Response<dynamic>> _uploadFile({
//   required String owner,
//   required String departmentName,
//   required String categoryName,
//   required String name,
//   required String description,
//   required int price,
//   required File image,
//   bool? guarantee,
//   String? madeIn,
//   DateTime? year,
//   String? address,
// }) async {
//   try {
//     Dio dio = Dio();
//     FormData formData = FormData.fromMap({
//       'owner': owner,
//       'departmentName': departmentName,
//       'categoryName': categoryName,
//       'name': name,
//       'description': description,
//       'price': price,
//       'image': await MultipartFile.fromFile(image.path,
//           filename: 'image.jpg', contentType: MediaType('image', 'jpeg')),
//       'guarantee': guarantee,
//       'madeIn': madeIn,
//       'year': year,
//       'address': address,
//     });

//     Response response = await dio.post(
//         'https://net-zoon.onrender.com/departments/addProduct',
//         data: formData);
//     // Handle the response as needed

//     return response;
//   } catch (e) {
//     rethrow;
//   }
// }

Future<Response<dynamic>> _uploadFile({
  required String owner,
  required String departmentName,
  required String categoryName,
  required String name,
  required String description,
  required int price,
  required File image,
  File? video,
  File? gif,
  bool? guarantee,
  String? madeIn,
  DateTime? year,
  String? address,
}) async {
  try {
    Dio dio = Dio();
    FormData formData = FormData();

    formData.fields.addAll([
      MapEntry('owner', owner),
      MapEntry('departmentName', departmentName),
      MapEntry('categoryName', categoryName),
      MapEntry('name', name),
      MapEntry('description', description),
      MapEntry('price', price.toString()),
      MapEntry('guarantee', guarantee.toString()),
      MapEntry('madeIn', madeIn ?? ''),
      MapEntry('year', year?.toString() ?? ''),
      MapEntry('address', address ?? ''),
    ]);

    if (image != null) {
      String fileName = 'image.jpg';
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      ));
    }

    if (video != null) {
      String fileName = 'video.mp4';
      formData.files.add(MapEntry(
        'video',
        await MultipartFile.fromFile(
          video.path,
          filename: fileName,
          contentType: MediaType('video', 'mp4'),
        ),
      ));
    }

    if (gif != null) {
      String fileName = 'gif.gif';
      formData.files.add(MapEntry(
        'gif',
        await MultipartFile.fromFile(
          gif.path,
          filename: fileName,
          contentType: MediaType('image', 'gif'),
        ),
      ));
    }

    Response response = await dio.post(
      'https://net-zoon.onrender.com/departments/addProduct',
      data: formData,
    );

    return response;
  } catch (e) {
    rethrow;
  }
}
