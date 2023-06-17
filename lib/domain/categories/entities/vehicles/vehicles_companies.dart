import 'package:equatable/equatable.dart';

class VehiclesCompanies extends Equatable {
  final String id;
  final String name;
  final String type;
  final String imgUrl;
  final String description;
  final String bio;
  final String mobile;
  final String mail;
  final String website;
  final String? coverUrl;

  const VehiclesCompanies(
      {required this.id,
      required this.name,
      required this.type,
      required this.imgUrl,
      required this.description,
      required this.bio,
      required this.mobile,
      required this.mail,
      required this.website,
      this.coverUrl});
  @override
  List<Object?> get props => [
        id,
        name,
        type,
        imgUrl,
        description,
        bio,
        mobile,
        mail,
        website,
        coverUrl
      ];
}
