import 'package:equatable/equatable.dart';

class FreeZoneCompany extends Equatable {
  final String categoryName;
  final String name;
  final String city;
  final String address;
  final String email;
  final String imgurl;
  final String? phone;
  final String? mobile;
  final List<Companies>? companies;
  final String info;
  final List<String> companyimages;
  final String? videourl;
  final String? link;

  const FreeZoneCompany(
      {required this.categoryName,
      required this.name,
      required this.city,
      required this.address,
      required this.email,
      required this.imgurl,
      this.phone,
      this.mobile,
      this.companies,
      required this.info,
      required this.companyimages,
      this.videourl,
      this.link});

  @override
  List<Object?> get props => [
        categoryName,
        name,
        city,
        address,
        email,
        imgurl,
        phone,
        mobile,
        companies,
        info,
        companyimages,
        videourl,
        link,
      ];
}

class Companies extends Equatable {
  final String name;
  final String image;

  const Companies({required this.name, required this.image});
  @override
  List<Object?> get props => [name, image];
}
