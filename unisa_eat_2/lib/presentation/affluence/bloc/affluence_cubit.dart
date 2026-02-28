import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/affluence/models/affluence_model.dart';
import 'package:unisa_eat_2/domain/affluence/usecases/get_affluence_usecase.dart';
import 'package:unisa_eat_2/service_locator.dart';

part 'affluence_state.dart';

class AffluenceCubit extends Cubit<AffluenceState> {
  AffluenceCubit() : super(AffluenceInitial());

  Future<void> fetchAffluence() async {
    emit(AffluenceLoading());
    var result = await sl<GetAffluenceUsecase>().call();
    result.fold(
      (error) => emit(AffluenceError(error)),
      (affluence) => emit(AffluenceLoaded(affluence)),
    );
  }
}