import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/domain/home/usecases/get_qr_code.dart';
import 'package:unisa_eat_2/service_locator.dart';

import 'qr_code_state.dart';

class QrCodeCubit extends Cubit<QrCodeState> {
  Timer? _countdownTimer;
  bool _isClosed = false;

  QrCodeCubit() : super(QrCodeInitial()) {
    startQrPolling();
  }

  void startQrPolling() {
    _pollQrCode();
  }

  Future<void> _pollQrCode() async {
    if (_isClosed) return;

    emit(QrCodeLoading());
    var result = await sl<GetQrcodeUsecase>().call();
    result.fold(
      (error) => {
        if (!_isClosed) emit(QrCodeFailure(error.toString()))
      },
      (token) {
        if (!_isClosed) {
          emit(QrCodeSuccess(token, remainingTime: 5.0));
          _startCountdown(token);
        }
      }
    );
  }

  void _startCountdown(String token) {
    if (_isClosed) return;

    _countdownTimer?.cancel();
    double remaining = 5.0;
    _countdownTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_isClosed) {
        timer.cancel();
        return;
      }

      remaining -= 0.05;
      if (remaining > 0) {
        emit(QrCodeSuccess(token, remainingTime: remaining));
      } else {
        timer.cancel();
        if (!_isClosed) {
          emit(QrCodeLoading());
          _pollQrCode();
        }
      }
    });
  }

  @override
  Future<void> close() async {
    _isClosed = true; // Set flag first
    _countdownTimer?.cancel();
    await super.close();
  }
}
