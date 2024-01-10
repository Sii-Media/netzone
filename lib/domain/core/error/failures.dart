abstract class Failure {}

class OfflineFailure extends Failure {}

class ServerFailure extends Failure {
  ServerFailure();
}

class EmptyCacheFailure extends Failure {}

class CredintialFailure extends Failure {}

class OTPValidFailure extends Failure {}

class FilteredFailure extends Failure {}

class RatingFailure extends Failure {}

class EmpltyDataFailure extends Failure {}

class ExictUserFailure extends Failure {}

class UnAuthorizedFailure extends Failure {}
