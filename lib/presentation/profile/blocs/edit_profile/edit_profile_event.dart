part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class OnEditProfileEvent extends EditProfileEvent {
  final String username;
  final String email;
  final String firstMobile;
  final String? secondeMobile;
  final String? thirdMobile;
  final File? profilePhoto;
  final File? coverPhoto;
  final File? frontIdPhoto;
  final File? backIdPhoto;
  final File? tradeLicensePhoto;
  final File? deliveryPermitPhoto;

  final String? bio;
  final String? description;
  final String? website;
  final String? link;
  final String? slogn;
  final String? address;
  final String contactName;
  final String? userType;
  final String? city;
  final String? addressDetails;
  const OnEditProfileEvent({
    required this.username,
    required this.email,
    required this.firstMobile,
    this.secondeMobile,
    this.thirdMobile,
    this.profilePhoto,
    this.coverPhoto,
    this.bio,
    this.description,
    this.website,
    this.link,
    this.slogn,
    this.address,
    required this.contactName,
    this.frontIdPhoto,
    this.backIdPhoto,
    this.tradeLicensePhoto,
    this.deliveryPermitPhoto,
    this.userType,
    this.city,
    this.addressDetails,
  });
}
