import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/data/faq/models/faq_model.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class FAQApiService {
  Future<Either<ApiError, List<FAQModel>>> getFAQs();
  Future<Either<ApiError, List<String>>> getCategories();
}

class FAQApiServiceImpl implements FAQApiService {
  @override
  Future<Either<ApiError, List<FAQModel>>> getFAQs() async {
    try {
      final response = await sl<DioClient>().get(ApiUrl.faqs);
      final List<dynamic> data = response.data as List<dynamic>;
      final faqs = data.map((json) => FAQModel.fromJson(json as Map<String, dynamic>)).toList();
      return Right(faqs);
    } catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, List<String>>> getCategories() async {
    try {
      final response = await sl<DioClient>().get('${ApiUrl.faqs}categories/');
      final data = response.data as Map<String, dynamic>;
      final categories = (data['categories'] as List<dynamic>).cast<String>().toList();
      return Right(categories);
    } catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }
}
