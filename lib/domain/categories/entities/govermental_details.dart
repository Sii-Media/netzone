import 'package:equatable/equatable.dart';

class GovermentalDetails extends Equatable {
  final String govname;
  final String name;
  final String city;
  final String address;
  final String email;
  final String imgurl;
  final String? phone;
  final String? mobile;
  final String info;
  final String? videourl;
  final String? link;

  const GovermentalDetails({
    required this.govname,
    required this.name,
    required this.city,
    required this.address,
    required this.email,
    required this.imgurl,
    this.phone,
    this.mobile,
    required this.info,
    this.videourl,
    this.link,
  });
  @override
  List<Object?> get props => [
        govname,
        name,
        city,
        address,
        email,
        imgurl,
        phone,
        mobile,
        info,
      ];
}
