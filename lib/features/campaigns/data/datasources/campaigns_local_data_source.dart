import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/campaigns_model.dart';

abstract class CampaignLocalDataSource {
  Future<List<CampaignModel>> getCachedCampaigns();
  Future<Unit> cacheCampaigns(List<CampaignModel> campaignModels);
}
const CACHED_CAMPAIGNS = "CACHED_CAMPAIGNS";

class CampaignLocalDataSourceImpl implements CampaignLocalDataSource {
  final SharedPreferences sharedPreferences;
  CampaignLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Unit> cacheCampaigns(List<CampaignModel> campaignModels) {
    final List<Map<String, dynamic>> campaignModelToJson = campaignModels
        .map<Map<String, dynamic>>((campaignModel) => campaignModel.toJson())
        .toList();

    sharedPreferences.setString(
      CACHED_CAMPAIGNS,
      jsonEncode(campaignModelToJson),
    );
    return Future.value(unit);
  }

  @override
  Future<List<CampaignModel>> getCachedCampaigns() {
    final jsonString = sharedPreferences.getString(CACHED_CAMPAIGNS);
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString);
      final List<CampaignModel> jsonToCampaignModels = decodedJson
          .map<CampaignModel>((jsonItem) => CampaignModel.fromJson(jsonItem))
          .toList();
      return Future.value(jsonToCampaignModels);
    } else {
      throw EmptyCacheException();
    }
  }
}
