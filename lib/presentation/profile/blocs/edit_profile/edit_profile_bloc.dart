import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/entities/user.dart';

import 'package:netzoon/domain/auth/usecases/edit_profile_use_case.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../domain/core/usecase/usecase.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfileUseCase editProfileUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  EditProfileBloc({
    required this.editProfileUseCase,
    required this.getSignedInUser,
  }) : super(EditProfileInitial()) {
    on<OnEditProfileEvent>((event, emit) async {
      emit(EditProfileInProgress());
      final result = await getSignedInUser.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);

      final response = await editProfileUseCase(
        EditProfileParams(
          userId: user.userInfo.id,
          username: event.username,
          email: event.email,
          firstMobile: event.firstMobile,
          secondeMobile: event.secondeMobile,
          thirdMobile: event.thirdMobile,
          profilePhoto: event.profilePhoto,
          coverPhoto: event.coverPhoto,
          bio: event.bio,
          description: event.description,
          link: event.link,
          slogn: event.slogn,
          website: event.website,
          address: event.address,
          contactName: event.contactName,
          addressDetails: event.addressDetails,
          backIdPhoto: event.backIdPhoto,
          city: event.city,
          deliveryPermitPhot: event.deliveryPermitPhoto,
          frontIdPhoto: event.frontIdPhoto,
          tradeLicensePhoto: event.tradeLicensePhoto,
          userType: event.userType,
        ),
      );
      emit(
        response.fold(
            (failure) => EditProfileFailure(
                  message: mapFailureToString(failure),
                  failure: failure,
                ), (userInfo) {
          return EditProfileSuccess(userInfo: userInfo);
        }),
      );
    });
  }
}
