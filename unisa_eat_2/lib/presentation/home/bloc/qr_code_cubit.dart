import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/domain/home/usecases/get_qr_code.dart';
import 'package:unisa_eat_2/presentation/home/bloc/qr_code_state.dart';
import 'package:unisa_eat_2/service_locator.dart';


class QrcodeCubit extends Cubit<QrcodeState> {
  QrcodeCubit() : super(QrcodeInitial());
  
  Timer? _timer;

  Future<void> startQrPolling() async {
    
    await _pollQrCode();
    
    _timer?.cancel(); 
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await _pollQrCode();
    });
  }

  Future<void> _pollQrCode() async {
    emit(QrcodeLoading());
    var result = await sl<GetQrcodeUsecase>().call();
    result.fold(
      (error) => emit(QrcodeError(error.toString())), 
      (token) => emit(QrcodeSuccess(token))
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  getQrCode() {}
}
