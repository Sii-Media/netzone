import 'package:equatable/equatable.dart';

class CompanyCategory extends Equatable {
  final String categoryName;
  final String name;
  final String city;
  final String address;
  final String email;
  final String imgurl;
  final String? phone;
  final String? mobile;
  final String info;
  final List<String> companyimages;
  final String? videourl;

  const CompanyCategory({
    required this.name,
    required this.categoryName,
    required this.city,
    required this.address,
    required this.email,
    required this.imgurl,
    this.phone,
    this.mobile,
    required this.info,
    required this.companyimages,
    this.videourl,
  });

  @override
  List<Object?> get props =>
      [name, categoryName, city, address, email, imgurl, info, companyimages];
}
