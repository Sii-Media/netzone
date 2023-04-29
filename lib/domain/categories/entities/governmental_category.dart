import 'package:equatable/equatable.dart';

class GovernmentalCategory extends Equatable {
  final String categoryName;
  final String name;
  final String city;
  final String address;
  final String email;
  final String imgurl;
  final String info;
  final List<String> companyimages;
  final String? videourl;

  const GovernmentalCategory({
    required this.name,
    required this.categoryName,
    required this.city,
    required this.address,
    required this.email,
    required this.imgurl,
    required this.info,
    required this.companyimages,
    this.videourl,
  });

  @override
  List<Object?> get props =>
      [name, categoryName, city, address, email, imgurl, info, companyimages];
}
