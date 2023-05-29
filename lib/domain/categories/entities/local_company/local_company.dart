import 'package:equatable/equatable.dart';

class LocalCompany extends Equatable {
  final String id;
  final String name;
  final String imgUrl;
  final String description;
  final String desc2;
  final String mobile;
  final String mail;
  final String website;
  final List<String> docs;

  const LocalCompany({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.description,
    required this.desc2,
    required this.mobile,
    required this.mail,
    required this.website,
    required this.docs,
  });

  @override
  List<Object?> get props =>
      [id, name, imgUrl, description, desc2, mobile, mail, website, docs];
}
