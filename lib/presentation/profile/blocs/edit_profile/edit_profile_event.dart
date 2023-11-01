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
  final String secondeMobile;
  final String thirdMobile;
  final File? profilePhoto;
  final String? bio;
  final String? description;
  final String? website;
  final String? link;
  final String? slogn;
  final String? address;
  final String contactName;
  const OnEditProfileEvent({
    required this.username,
    required this.email,
    required this.firstMobile,
    required this.secondeMobile,
    required this.thirdMobile,
    this.profilePhoto,
    this.bio,
    this.description,
    this.website,
    this.link,
    this.slogn,
    this.address,
    required this.contactName,
  });
}
