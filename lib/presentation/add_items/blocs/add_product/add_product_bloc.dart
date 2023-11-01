import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';
import 'package:netzoon/domain/departments/usecases/add_product_use_case.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../domain/core/usecase/usecase.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final AddProductUseCase addProductUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  final GetCountryUseCase getCountryUseCase;
  AddProductBloc({
    required this.addProductUseCase,
    required this.getSignedInUser,
    required this.getCountryUseCase,
  }) : super(AddProductInitial()) {
    on<AddProductRequestedEvent>((event, emit) async {
      emit(AddProductInProgress());
      final result = await getSignedInUser.call(NoParams());
      late User? user;
      result.fold((l) => null, (r) => user = r);

      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');

      final Response response = await _uploadFile(
        owner: user?.userInfo.id ?? '',
        departmentName: event.departmentName,
        categoryName: event.categoryName,
        name: event.name,
        condition: event.condition,
        description: event.description,
        price: event.price,
        weight: event.weight,
        quantity: event.quantity,
        image: event.image,
        productimages: event.productimages,
        video: event.video,
        guarantee: event.guarantee,
        madeIn: event.madeIn,
        year: event.year,
        address: event.address,
        discountPercentage: event.discountPercentage,
        country: country,
        color: event.color,
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
//         'http://192.168.0.191:5000/departments/addProduct',
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
  required String? condition,
  required String name,
  required String description,
  required int price,
  required double weight,
  required int quantity,
  required File image,
  List<XFile>? productimages,
  File? video,
  File? gif,
  bool? guarantee,
  String? madeIn,
  DateTime? year,
  String? address,
  int? discountPercentage,
  required String country,
  String? color,
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
      MapEntry('weight', weight.toString()),
      MapEntry('quantity', quantity.toString()),
      MapEntry('guarantee', guarantee.toString()),
      MapEntry('madeIn', madeIn ?? ''),
      MapEntry('year', year?.toString() ?? ''),
      MapEntry('address', address ?? ''),
      MapEntry('discountPercentage', discountPercentage.toString()),
      MapEntry('country', country),
    ]);
    if (condition != null) {
      formData.fields.add(
        MapEntry('condition', condition),
      );
    }
    if (color != null) {
      formData.fields.add(
        MapEntry('color', color),
      );
    }
    // ignore: unnecessary_null_comparison
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
    if (productimages != null && productimages.isNotEmpty) {
      for (int i = 0; i < productimages.length; i++) {
        String fileName = 'image$i.jpg';
        File file = File(productimages[i].path);
        formData.files.add(MapEntry(
          'productimages',
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        ));
      }
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
      'http://192.168.0.191:5000/departments/addProduct',
      data: formData,
    );

    return response;
  } catch (e) {
    rethrow;
  }
}
