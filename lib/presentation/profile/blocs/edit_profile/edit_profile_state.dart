part of 'edit_profile_bloc.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileInProgress extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final String userInfo;

  const EditProfileSuccess({required this.userInfo});
}

class EditProfileFailure extends EditProfileState {
  final String message;
  final Failure failure;
  const EditProfileFailure({required this.message, required this.failure});
}
