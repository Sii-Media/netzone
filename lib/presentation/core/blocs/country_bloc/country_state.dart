part of 'country_bloc.dart';

abstract class CountryState extends Equatable {
  final String selectedCountry;
  const CountryState(this.selectedCountry);

  @override
  List<Object> get props => [selectedCountry];
}

class CountryInitial extends CountryState {
  const CountryInitial(
    super.selectedCountry,
  );
  @override
  List<Object> get props => [selectedCountry];
}

class SetCountryState extends CountryState {
  const SetCountryState(super.selectedCountry);
  @override
  List<Object> get props => [selectedCountry];
}

class GetCountrySuccessState extends CountryState {
  final String country;
  const GetCountrySuccessState({required this.country}) : super(country);
}

// class CountryUpdatedSuccess extends CountryState {
//   final String selectedCountry;

//   const CountryUpdatedSuccess({required this.selectedCountry});
//   @override
//   List<Object> get props => [selectedCountry];
// }
