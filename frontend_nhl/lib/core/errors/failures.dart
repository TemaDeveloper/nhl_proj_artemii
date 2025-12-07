import 'package:equatable/equatable.dart';

/// Base class for all failures in the app.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Server-related failures (Firestore, API, etc).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Network connectivity failures.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Permission/authorization failures.
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Cache-related failures.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Data parsing/validation failures.
class DataFailure extends Failure {
  const DataFailure(super.message);
}