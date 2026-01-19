import 'package:logger/logger.dart';
import 'package:unisa_eat_2/domain/shared/usecases/get_server_time_usecase.dart';
import 'package:unisa_eat_2/service_locator.dart';

class TimeService {
  DateTime? _serverTime;
  DateTime? _syncTime;

  Logger logger = sl<Logger>();

  Future<bool> syncServerTime() async {
    try {
      var result = await sl<GetServerTimeUsecase>().call();
      return result.fold(
        (error) {
          logger.e('Failed to sync server time: ${error.message}');
          return false;
        },
        (serverTime) {
          _serverTime = serverTime;
          _syncTime = DateTime.now();
          logger.d('Server time synced: $_serverTime');
          return true;
        },
      );
    } catch (e) {
      logger.e('Exception syncing server time: $e');
      return false;
    }
  }

  DateTime now() {
    if (_serverTime == null || _syncTime == null) {
      return DateTime.now();
    }
    Duration diff = DateTime.now().difference(_syncTime!);
    return _serverTime!.add(diff);
  }

  bool isSynced() => _serverTime != null;
}