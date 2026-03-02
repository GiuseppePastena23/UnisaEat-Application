
import 'package:dartz/dartz.dart';

abstract class HomeRepository {

  Future<Either> getQrcode();
  Future<Either> getOrderQrcode(int orderId);

}