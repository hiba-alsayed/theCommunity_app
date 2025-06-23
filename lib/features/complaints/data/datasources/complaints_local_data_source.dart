import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../campaigns/data/models/campaigns_model.dart';
import '../models/complaints_model.dart';

abstract class ComplaintLocalDataSource {
  Future<List<ComplaintModel>> getCachedCampaigns();
  Future<Unit> cacheComplaints(List<ComplaintModel> complaintModel);
}

const CACHED_COMPLAINTS = "CACHED_COMPLAINTS";

class ComplaintLocalDataSourceImpl implements ComplaintLocalDataSource {
  final SharedPreferences sharedPreferences;

  ComplaintLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Unit> cacheComplaints(List<ComplaintModel> complaintModel) {
    final List<Map<String, dynamic>> campaignModelToJson = complaintModel
        .map<Map<String, dynamic>>((campaignModel) => campaignModel.toJson())
        .toList();

    sharedPreferences.setString(
      CACHED_COMPLAINTS,
      jsonEncode(campaignModelToJson),
    );
    return Future.value(unit);
  }

  @override
  Future<List<ComplaintModel>> getCachedCampaigns() {
    final jsonString = sharedPreferences.getString(CACHED_COMPLAINTS);
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString);
      final List<ComplaintModel> jsonToCampaignModels = decodedJson
          .map<ComplaintModel>((jsonItem) => ComplaintModel.fromJson(jsonItem))
          .toList();
      return Future.value(jsonToCampaignModels);
    } else {
      throw EmptyCacheException();
    }
  }

}
