
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/core/services/auth_service.dart';
import 'package:unisa_eat_2/domain/user/usecases/get_user.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_state.dart';
import 'package:unisa_eat_2/service_locator.dart';

class UserProfileCubit extends Cubit<UserProfileState>{
    DateTime? _lastRefresh;

    UserProfileCubit() : super(UserProfileInitial()){
      // Auto-load user data if authenticated
      _checkAuthAndLoadUser();
    }

    void _checkAuthAndLoadUser() {
      final authService = sl<AuthService>();
      authService.isTokenValid().then((isAuthenticated) {
        if (isAuthenticated) {
          getUser(); // Load user data if authenticated
        }
      });
    }

    void getUser({bool forceRefresh = false}) async {
      emit(UserProfileLoading()); // Simula un ritardo di caricamento
      var result = await sl<GetUserUsecase>().call(params: GetUserParams(forceRefresh: forceRefresh));
        result.fold(
            (error) => emit(UserProfileFailure(error.toString())),
            (user) {
              _lastRefresh = DateTime.now();
              emit(UserProfileSuccess(user));
            }
        );

    }

    void refreshUserIfNeeded({Duration maxAge = const Duration(minutes: 5)}) {
      final now = DateTime.now();
      if (_lastRefresh == null || now.difference(_lastRefresh!) > maxAge) {
        _lastRefresh = now;
        getUser(forceRefresh: true);
      }
    }

    void reset() {
      emit(UserProfileInitial());
    }
}