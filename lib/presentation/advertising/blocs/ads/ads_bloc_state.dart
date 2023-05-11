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
