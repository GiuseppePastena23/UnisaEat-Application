import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/data/feedback/models/feedback_model.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class FeedbackApiService {
  Future<Either<ApiError, List<FeedbackModel>>> getFeedback();
  Future<Either<ApiError, FeedbackModel>> createFeedback(String category, String message);
}

class FeedbackApiServiceImpl implements FeedbackApiService {
  @override
  Future<Either<ApiError, List<FeedbackModel>>> getFeedback() async {
    try {
      final response = await sl<DioClient>().get(ApiUrl.feedback);
      final List<dynamic> data = response.data as List<dynamic>;
      final feedbackList = data.map((json) => FeedbackModel.fromJson(json as Map<String, dynamic>)).toList();
      return Right(feedbackList);
    } catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, FeedbackModel>> createFeedback(String category, String message) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrl.feedback,
        data: {
          'category': category,
          'message': message,
        },
      );
      final feedback = FeedbackModel.fromJson(response.data as Map<String, dynamic>);
      return Right(feedback);
    } catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }
}
