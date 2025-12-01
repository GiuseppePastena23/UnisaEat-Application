import 'package:dartz/dartz.dart';

abstract class WalletRepository {

  Future<Either> getBalance();

}