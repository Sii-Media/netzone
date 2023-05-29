import 'package:equatable/equatable.dart';

class GovermentalDetails extends Equatable {
  final String id;
  final String govname;
  final String name;
  final String imgurl;
  final String city;
  final String address;
  final String email;
  final List<String> images;
  final String? phone;
  final String? mobile;
  final String info;
  final String? videourl;
  final String? link;

  const GovermentalDetails({
    required this.id,
    required this.govname,
    required this.name,
    required this.imgurl,
    required this.city,
    required this.address,
    required this.email,
    required this.images,
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
        imgurl,
        city,
        address,
        email,
        images,
        phone,
        mobile,
        info,
        videourl,
        link,
      ];
}
