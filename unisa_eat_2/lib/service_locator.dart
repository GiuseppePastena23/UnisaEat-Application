import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import 'package:unisa_eat_2/core/configs/constants/hive_boxes.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/core/services/auth_service.dart';
import 'package:unisa_eat_2/core/services/time_service.dart';

import 'package:unisa_eat_2/data/auth/repositories/auth_repository.dart';
import 'package:unisa_eat_2/data/auth/sources/auth_api_service.dart';
import 'package:unisa_eat_2/data/home/repositories/home_repository.dart';
import 'package:unisa_eat_2/data/home/sources/home_api_service.dart';
import 'package:unisa_eat_2/data/menu/repositories/dish_repository.dart';
import 'package:unisa_eat_2/data/menu/repositories/menu_repository.dart';
import 'package:unisa_eat_2/data/menu/sources/dish_api_service.dart';
import 'package:unisa_eat_2/data/menu/sources/menu_api_service.dart';
import 'package:unisa_eat_2/data/user/repositories/user_repository.dart';
import 'package:unisa_eat_2/data/user/sources/user_api_service.dart';
import 'package:unisa_eat_2/data/order/repositories/order_repository.dart';
import 'package:unisa_eat_2/data/order/sources/order_api_service.dart';
import 'package:unisa_eat_2/data/shared/repositories/time_repository.dart';
import 'package:unisa_eat_2/data/shared/sources/time_api_service.dart';
import 'package:unisa_eat_2/data/affluence/repositories/affluence_repository.dart';
import 'package:unisa_eat_2/data/affluence/sources/affluence_api_service.dart';
import 'package:unisa_eat_2/data/wallet/repositories/wallet_repository.dart';
import 'package:unisa_eat_2/data/wallet/sources/wallet_api_service.dart';
import 'package:unisa_eat_2/domain/affluence/usecases/get_affluence_usecase.dart';
import 'package:unisa_eat_2/domain/auth/repositories/auth_repository.dart';
import 'package:unisa_eat_2/domain/auth/usecases/login.dart';
import 'package:unisa_eat_2/domain/auth/usecases/logout.dart';
import 'package:unisa_eat_2/domain/auth/usecases/register.dart';
import 'package:unisa_eat_2/domain/home/repositories/home_repository.dart';
import 'package:unisa_eat_2/domain/home/usecases/get_qr_code.dart';
import 'package:unisa_eat_2/domain/menu/repository/menu_repository.dart';
import 'package:unisa_eat_2/domain/menu/usecases/get_dishes_usecase.dart';
import 'package:unisa_eat_2/domain/menu/usecases/get_menu_by_date_usecase.dart';
import 'package:unisa_eat_2/domain/order/repositories/order_repository.dart';
import 'package:unisa_eat_2/domain/order/usecases/create_order_usecase.dart';
import 'package:unisa_eat_2/domain/order/usecases/get_orders_usecase.dart';

import 'package:unisa_eat_2/domain/shared/usecases/get_server_time_usecase.dart';
import 'package:unisa_eat_2/domain/user/entities/cached_user.dart';

import 'package:unisa_eat_2/domain/user/repositories/user_repository.dart';
import 'package:unisa_eat_2/domain/user/usecases/get_user.dart';
import 'package:unisa_eat_2/domain/wallet/repositories/wallet_repository.dart';
import 'package:unisa_eat_2/domain/wallet/usecases/get_balance_usecase.dart';
import 'package:unisa_eat_2/domain/wallet/usecases/get_transactions_usecase.dart';

final sl  = GetIt.instance;

void setupServiceLocator() {
  
  sl.registerSingleton<Box<CachedUser>>(Hive.box<CachedUser>(HiveBoxes.user));


  



  // Services
  sl.registerSingleton<Logger>(Logger());
  sl.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());
   sl.registerSingleton<AuthService>(AuthService(sl<FlutterSecureStorage>()));
   sl.registerSingleton<TimeService>(TimeService());

  // Network
  sl.registerSingleton<DioClient>(DioClient());
  
    // ApiService
    sl.registerSingleton<WalletApiService>(WalletApiServiceImpl());
    sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
    sl.registerSingleton<UserApiService>(UserApiServiceImpl());
    sl.registerSingleton<HomeApiService>(HomeApiServiceImpl());
     sl.registerSingleton<MenuApiService>(MenuApiServiceImpl());
      sl.registerSingleton<DishApiService>(DishApiServiceImpl());
     sl.registerSingleton<OrderApiService>(OrderApiServiceImpl());
     sl.registerSingleton<TimeApiService>(TimeApiServiceImpl());
     sl.registerSingleton<AffluenceApiService>(AffluenceApiServiceImpl());

    // Repositories
    sl.registerSingleton<WalletRepository>(WalletRepositoryImpl());
    sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
    sl.registerSingleton<UserRepository>(UserRepositoryImpl());
    sl.registerSingleton<HomeRepository>(HomeRepositoryImpl());
      sl.registerSingleton<MenuRepository>(MenuRepositoryImpl());
      sl.registerSingleton<DishRepository>(DishRepositoryImpl());
     sl.registerSingleton<OrderRepository>(OrderRepositoryImpl());
     sl.registerSingleton<TimeRepository>(TimeRepositoryImpl());
     sl.registerSingleton<AffluenceRepository>(AffluenceRepositoryImpl(sl<AffluenceApiService>()));
  
     // Usecases
     sl.registerSingleton<GetTransactionsUsecase>(GetTransactionsUsecase());
     sl.registerSingleton<GetBalanceUsecase>(GetBalanceUsecase());
     sl.registerSingleton<LoginUsecase>(LoginUsecase());
     sl.registerSingleton<RegisterUsecase>(RegisterUsecase(sl()));
     sl.registerSingleton<GetUserUsecase>(GetUserUsecase());
     sl.registerSingleton<LogoutUsecase>(LogoutUsecase());
     sl.registerSingleton<GetQrcodeUsecase>(GetQrcodeUsecase());
      sl.registerSingleton<GetMenuByDateUsecase>(GetMenuByDateUsecase());
      sl.registerSingleton<GetDishesUsecase>(GetDishesUsecase());
       sl.registerSingleton<GetOrdersUsecase>(GetOrdersUsecase());
       sl.registerSingleton<CreateOrderUsecase>(CreateOrderUsecase(sl<OrderRepository>()));
       sl.registerSingleton<GetServerTimeUsecase>(GetServerTimeUsecase());
       sl.registerSingleton<GetAffluenceUsecase>(GetAffluenceUsecaseImpl(sl<AffluenceRepository>()));

}

