part of 'ads_bloc_bloc.dart';

abstract class AdsBlocState extends Equatable {
  const AdsBlocState();

  @override
  List<Object> get props => [];
}

class AdsBlocInitial extends AdsBlocState {}

class AdsBlocInProgress extends AdsBlocState {}

class AdsBlocSuccess extends AdsBlocState {
  final List<Advertisement> ads;

  const AdsBlocSuccess({required this.ads});
}

class AdsBlocFailure extends AdsBlocState {
  final String message;

  const AdsBlocFailure({required this.message});
}

class GetAdsByIdSuccess extends AdsBlocState {
  final Advertisement ads;

  const GetAdsByIdSuccess({required this.ads});
}

class EditAdsInProgress extends AdsBlocState {}

class EditAdsFailure extends AdsBlocState {
  final String message;

  const EditAdsFailure({required this.message});
}

class EditAdsSuccess extends AdsBlocState {
  final String message;

  const EditAdsSuccess({required this.message});
}

class DeleteAdsInProgress extends AdsBlocState {}

class DeleteAdsFailure extends AdsBlocState {
  final String message;

  const DeleteAdsFailure({required this.message});
}

class DeleteAdsSuccess extends AdsBlocState {
  final String message;

  const DeleteAdsSuccess({required this.message});
}

class AddAdsVisitorFailure extends AdsBlocState {
  final String message;

  const AddAdsVisitorFailure({required this.message});
}

class AddAdsVisitorSuccess extends AdsBlocState {
  final String message;

  const AddAdsVisitorSuccess({required this.message});
}
