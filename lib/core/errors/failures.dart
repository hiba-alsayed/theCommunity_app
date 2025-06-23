import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmptyCacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class WrongDataFailure extends Failure{
  @override

  List<Object?> get props => [];
}

class DuplicateVoteFailure extends Failure {
  final String message;
  DuplicateVoteFailure({required this.message});

  @override
  List<Object?> get props => [];
}

class AlreadyJoinedFailure extends Failure {
  final String message;
  AlreadyJoinedFailure({required this.message});

  @override
  List<Object?> get props => [];
}

class AlreadyRatedFailure extends Failure {
  @override
  List<Object?> get props => [];
}

