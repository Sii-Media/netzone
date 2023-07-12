part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends SignUpEvent {
  final String username;
  final String email;
  final String password;
  final String userType;
  final String firstMobile;
  final String? secondMobile;
  final String? thirdMobile;
  final String? subcategory;
  final String? address;
  final int? companyProductsNumber;
  final String? sellType;
  final String? toCountry;

  final bool isFreeZoon;
  final bool? deliverable;
  final File? profilePhoto;
  final File? coverPhoto;
  final File? banerPhoto;
  final File? frontIdPhoto;
  final File? backIdPhoto;
  final String? bio;
  final String? description;
  final String? website;

  const SignUpRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.userType,
    required this.firstMobile,
    this.secondMobile,
    this.thirdMobile,
    this.subcategory,
    this.address,
    this.companyProductsNumber,
    this.sellType,
    this.toCountry,
    required this.isFreeZoon,
    this.deliverable,
    this.profilePhoto,
    this.coverPhoto,
    this.banerPhoto,
    this.frontIdPhoto,
    this.backIdPhoto,
    this.bio,
    this.description,
    this.website,
  });
}
