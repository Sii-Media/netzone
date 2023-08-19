import 'package:netzoon/domain/core/error/failures.dart';

String mapFailureToString(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return "ServerFailure";
    case EmptyCacheFailure:
      return "EmptyCacheFailure";
    case OfflineFailure:
      return "Offline Failure";
    case CredintialFailure:
      return 'Credintial Failure';
    case OTPValidFailure:
      return 'InValid OTP';
    case FilteredFailure:
      return 'No products found with the provided filters';
    case EmpltyDataFailure:
      return 'No data founded';
    case RatingFailure:
      return 'You have already rated this';
    default:
      return "UnExpected Error, Please try again later.";
  }
}
