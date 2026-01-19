import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/data/affluence/models/affluence_model.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class AffluenceApiService {
  Future<Either<String, AffluenceModel>> getAffluence();
}

class AffluenceApiServiceImpl implements AffluenceApiService {
  @override
  Future<Either<String, AffluenceModel>> getAffluence() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final debug = prefs.getBool('debug_mode') ?? false;
      final queryParams = debug ? {'debug': 'true'} : null;
      var response = await sl<DioClient>().get(ApiUrl.affluence, queryParameters: queryParams);
      var data = response.data as Map<String, dynamic>;
      var model = AffluenceModel.fromJson(data);
      return Right(model);
    } catch (e) {
      return Left('Failed to fetch affluence: $e');
    }
  }
}