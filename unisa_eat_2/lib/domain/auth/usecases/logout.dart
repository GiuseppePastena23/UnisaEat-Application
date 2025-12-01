import 'package:unisa_eat_2/common/helper/router/app_router.dart';
import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/domain/auth/repositories/auth_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class LogoutUsecase extends Usecase<void, void> {
  @override
  Future<void> call({void params}) async {
    
    await sl<AuthRepository>().logout();
    
  
    appRouter.go('/login');
    

  }

} 