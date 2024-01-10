part of 'add_ads_bloc.dart';

abstract class AddAdsState extends Equatable {
  const AddAdsState();

  @override
  List<Object> get props => [];
}

class AddAdsInitial extends AddAdsState {}

class AddAdsInProgress extends AddAdsState {}

class AddAdsSuccess extends AddAdsState {
  final String msg;

  const AddAdsSuccess({required this.msg});
}

class AddAdsFailure extends AddAdsState {
  final String message;
  final Failure failure;
  const AddAdsFailure({
    required this.message,
    required this.failure,
  });
}
