
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/domain/user/usecases/get_user.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_state.dart';
import 'package:unisa_eat_2/service_locator.dart';

class UserProfileCubit extends Cubit<UserProfileState>{

    UserProfileCubit() : super(UserProfileInitial());
 
    void getUser() async {
      emit(UserProfileLoading()); // Simula un ritardo di caricamento
      var result = await sl<GetUserUsecase>().call();
        result.fold(
            (error) => emit(UserProfileFailure(error.toString())),
            (user) => emit(UserProfileSuccess(user))
        );

    }
} 