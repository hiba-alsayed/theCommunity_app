import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/core/network/network_info.dart';
import 'package:graduation_project/features/suggestions/data/datasources/suggestion_local_data_source.dart';
import 'package:graduation_project/features/suggestions/data/datasources/suggestion_remote_data_source.dart';
import 'package:graduation_project/features/suggestions/data/models/Suggestion_model.dart';
import 'package:graduation_project/features/suggestions/domain/entities/Suggestions.dart';
import 'package:graduation_project/features/suggestions/presentation/bloc/suggestion_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/suggestions_repository.dart';

class SuggestionsRepositoryImp implements SuggestionsRepository {
  final SuggestionRemoteDataSource remoteDataSource;
  final SuggestionLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SuggestionsRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Suggestions>>> getAllSuggestions() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSuggestions = await remoteDataSource.getAllSuggestions();
        localDataSource.cashSuggestions(remoteSuggestions);
        return Right(remoteSuggestions);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localSuggestions = await localDataSource.getCashedSuggestions();
        return Right(localSuggestions);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }


  @override
  Future<Either<Failure, List<Suggestions>>> getAllSuggestionsByCategory(
      int categoryId,) async {
    try {
      final suggestion = await remoteDataSource.getAllSuggestionsByCategory(
        categoryId,
      );
      return Right(suggestion);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> submitSuggestion({
    required String title,
    required String description,
    required String requiredAmount,
    required String area,
    required double longitude,
    required double latitude,
    required dynamic categoryId,
    required dynamic numberOfParticipants,
    required dynamic imageUrl,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.submitSuggestion(
          title: title,
          description: description,
          requiredAmount: requiredAmount,
          area: area,
          longitude: longitude,
          latitude: latitude,
          categoryId: categoryId,
          numberOfParticipants: numberOfParticipants,
          imageUrl: imageUrl,
        );
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> voteOnSuggestion({
    required int suggestionId,
    required int value,
  }) async {
    try {
      final result = await remoteDataSource.voteOnSuggestion(
        suggestionId: suggestionId,
        value: value,
      );
      return Right(result);
    } on DuplicateVoteException catch (e) {
      return Left(DuplicateVoteFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Suggestions>>> getNearbySuggestions({
    required int categoryId,
    required double distance,
  }) async {
    try {
      final suggestions = await remoteDataSource.getNearbySuggestions(
        categoryId: categoryId,
        distance: distance,
      );
      return Right(suggestions);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Suggestions>>> getMySuggestions() async {
    if (await networkInfo.isConnected) {
      try {
        final mySuggestions = await remoteDataSource.getMySuggestions();
        return Right(mySuggestions);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMySuggestion(int suggestionId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteMySuggestion(suggestionId);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
