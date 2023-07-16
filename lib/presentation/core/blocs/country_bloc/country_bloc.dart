import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';
import 'package:netzoon/domain/core/usecase/set_country_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final GetCountryUseCase getCountryUseCase;
  final SetCountryUseCase setCountryUseCase;
  CountryBloc({
    required this.getCountryUseCase,
    required this.setCountryUseCase,
  }) : super(const CountryInitial('AE')) {
    on<UpdateCountryEvent>((event, emit) async {
      await setCountryUseCase(event.country);
      emit(CountryInitial(event.country));
    });
    on<GetCountryEvent>((event, emit) async {
      final country = await getCountryUseCase(NoParams());
      emit(
        country.fold(
          (l) => const CountryInitial('AE'),
          (selectedCountry) => CountryInitial(selectedCountry ?? 'AE'),
        ),
      );
    });
    on<SetCountryEvent>((event, emit) async {
      await setCountryUseCase(event.country);
    });
  }
}
