import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/usecases/sign_up_use_case.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/core/usecase/usecase.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase signUpUseCase;
  final GetCountryUseCase getCountryUseCase;
  SignUpBloc({
    required this.signUpUseCase,
    required this.getCountryUseCase,
  }) : super(SignUpInitial()) {
    on<SignUpEvent>((event, emit) async {
      if (event is SignUpRequested) {
        emit(SignUpInProgress());

        late String country;
        final countryresult = await getCountryUseCase(NoParams());
        countryresult.fold((l) => null, (r) => country = r ?? 'AE');
        final failureOrUser = await signUpUseCase(SignUpUseCaseParams(
          username: event.username,
          email: event.email,
          password: event.password,
          userType: event.userType,
          firstMobile: event.firstMobile,
          secondMobile: event.secondMobile,
          thirdMobile: event.thirdMobile,
          address: event.address,
          companyProductsNumber: event.companyProductsNumber,
          sellType: event.sellType,
          subcategory: event.subcategory,
          toCountry: event.toCountry,
          isFreeZoon: event.isFreeZoon,
          deliverable: event.deliverable,
          profilePhoto: event.profilePhoto,
          coverPhoto: event.coverPhoto,
          banerPhoto: event.banerPhoto,
          frontIdPhoto: event.frontIdPhoto,
          backIdPhoto: event.backIdPhoto,
          bio: event.bio,
          description: event.description,
          website: event.website,
          title: event.title,
          country: country,
        ));

        emit(failureOrUser.fold(
            (failure) => (SignUpFailure(message: mapFailureToString(failure))),
            (user) => (SignUpSuccess(user: user))));
      }
    });
  }
}
