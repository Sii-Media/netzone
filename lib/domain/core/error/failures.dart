abstract class Failure {}

class OfflineFailure extends Failure {}

class ServerFailure extends Failure {
  ServerFailure();
}

class EmptyCacheFailure extends Failure {}

class CredintialFailure extends Failure {}
