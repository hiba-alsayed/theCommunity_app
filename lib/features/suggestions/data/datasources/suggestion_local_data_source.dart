import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/Suggestion_model.dart';

abstract class SuggestionLocalDataSource {
  Future<List<SuggestionModel>> getCashedSuggestions();
  Future<Unit> cashSuggestions(List<SuggestionModel> suggestionsModel);
}
const CASHED_SUGGESTIONS="CASHED_SUGGESTIONS";

class SuggestionLocalDataSourceImp implements SuggestionLocalDataSource {
  final SharedPreferences sharedPreferences;

  SuggestionLocalDataSourceImp({required this.sharedPreferences});
  @override
  Future<Unit> cashSuggestions(List<SuggestionModel> suggestionsModel) {
    List suggestionsModelToJson =
        suggestionsModel
            .map<Map<String, dynamic>>(
              (suggestionsModel) => suggestionsModel.toJson(),
            )
            .toList();
    sharedPreferences.setString(
      CASHED_SUGGESTIONS,
      jsonEncode(suggestionsModelToJson),
    );
    return Future.value(unit);
  }

  @override
  Future<List<SuggestionModel>> getCashedSuggestions() {
    final jsonString = sharedPreferences.getString(CASHED_SUGGESTIONS);
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<SuggestionModel> jsonToSuggestionsModel =
          decodeJsonData
              .map<SuggestionModel>(
                (jsonSuggestionModel) =>
                    SuggestionModel.fromJson(jsonSuggestionModel),
              )
              .toList();
      return Future.value(jsonToSuggestionsModel);
    } else {
      throw EmptyCacheException();
    }
  }
}
