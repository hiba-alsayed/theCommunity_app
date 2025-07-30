import 'package:flutter/material.dart';

class ServerException implements Exception {
  final int? statusCode;
  final String? message;
  ServerException({this.statusCode, this.message});
}

class EmptyCacheException implements Exception {}

class OfflineException implements Exception {}

class WrongDataException implements Exception {}

class AlreadyJoinedException implements Exception {}

class DuplicateVoteException implements Exception {
  final String message;
  DuplicateVoteException(this.message);
}

class AlreadyRatedException  implements Exception {
  final String message;
  AlreadyRatedException (this.message);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}