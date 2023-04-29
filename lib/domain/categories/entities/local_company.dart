import 'package:equatable/equatable.dart';

class LocalCompany extends Equatable {
  final String name;
  final String imgUrl;
  final String description;
  final String desc2;
  final String mobile;
  final String mail;
  final String website;
  final List<String> images;

  const LocalCompany({
    required this.name,
    required this.imgUrl,
    required this.description,
    required this.desc2,
    required this.mobile,
    required this.mail,
    required this.website,
    required this.images,
  });

  @override
  List<Object?> get props => [name, imgUrl];
}
