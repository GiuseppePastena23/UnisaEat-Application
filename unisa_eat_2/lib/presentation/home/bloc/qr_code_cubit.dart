import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/domain/home/usecases/get_qr_code.dart';
import 'package:unisa_eat_2/presentation/home/bloc/qr_code_state.dart';
import 'package:unisa_eat_2/service_locator.dart';


class QrcodeCubit extends Cubit<QrcodeState> {
  QrcodeCubit() : super(QrcodeInitial());
  
  Timer? _timer;
  Timer? _countdownTimer;
  bool _isClosed = false;

  Future<void> startQrPolling() async {
    if (_isClosed) return;
    
    await _pollQrCode();
    
    _timer?.cancel(); 
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (_isClosed) {
        timer.cancel();
        return;
      }
      await _pollQrCode();
    });
  }

  Future<void> _pollQrCode() async {
    if (_isClosed) return;
    
    emit(QrcodeLoading());
    var result = await sl<GetQrcodeUsecase>().call();
    result.fold(
      (error) => {
        if (!_isClosed) emit(QrcodeError(error.toString()))
      }, 
      (token) {
        if (!_isClosed) {
          emit(QrcodeSuccess(token, remainingTime: 5.0));
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
        emit(QrcodeSuccess(token, remainingTime: remaining));
      } else {
        timer.cancel();
        if (!_isClosed) {
          emit(QrcodeLoading());
          _pollQrCode();
        }
      }
    });
  }

  @override
  Future<void> close() async {
    _isClosed = true; // Set flag first
    _timer?.cancel();
    _countdownTimer?.cancel();
    await super.close();
  }
}

