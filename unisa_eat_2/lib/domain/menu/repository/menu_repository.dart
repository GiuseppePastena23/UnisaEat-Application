import 'package:dartz/dartz.dart';

abstract class MenuRepository {
  Future<Either> getMenuByDate(String date);
}