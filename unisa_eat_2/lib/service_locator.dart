import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/core/services/auth_service.dart';
import 'package:unisa_eat_2/data/auth/repositories/auth_repository.dart';
import 'package:unisa_eat_2/data/auth/sources/auth_api_service.dart';
import 'package:unisa_eat_2/domain/auth/repositories/auth_repository.dart';
import 'package:unisa_eat_2/domain/auth/usecases/login.dart';

final sl  = GetIt.instance;

void setupServiceLocator() {

  // Services
  sl.registerSingleton<Logger>(Logger(printer: PrettyPrinter(methodCount: 0, colors: true,printEmojis: true)));
  sl.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());
  sl.registerSingleton<AuthService>(AuthService(sl<FlutterSecureStorage>()));

  // Network
  sl.registerSingleton<DioClient>(DioClient());
  
  // ApiService
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  
  // Usecases
  sl.registerSingleton<LoginUsecase>(LoginUsecase());

}