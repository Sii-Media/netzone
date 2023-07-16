part of 'country_bloc.dart';

abstract class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object> get props => [];
}

class UpdateCountryEvent extends CountryEvent {
  final String country;

  const UpdateCountryEvent(this.country);

  @override
  List<Object> get props => [country];
}

class SetCountryEvent extends CountryEvent {
  final String country;

  const SetCountryEvent({required this.country});
  @override
  List<Object> get props => [country];
}

class GetCountryEvent extends CountryEvent {}
