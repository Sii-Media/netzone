part of 'fees_bloc.dart';

class FeesState extends Equatable {
  const FeesState();

  @override
  List<Object> get props => [];
}

class FeesInitial extends FeesState {}

class GetFeesInProgress extends FeesState {}

class GetFeesFailure extends FeesState {
  final String message;

  const GetFeesFailure({required this.message});
}

class GetFeesSuccess extends FeesState {
  final FeesResponse fees;

  const GetFeesSuccess({required this.fees});
}
