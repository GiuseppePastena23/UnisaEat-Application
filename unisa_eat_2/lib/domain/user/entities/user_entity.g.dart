// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserEntityAdapter extends TypeAdapter<UserEntity> {
  @override
  final int typeId = 0;

  @override
  UserEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserEntity(
      codiceFiscale: fields[0] as String?,
      cognome: fields[1] as String?,
      email: fields[2] as String?,
      nome: fields[3] as String?,
      saldo: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, UserEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.codiceFiscale)
      ..writeByte(1)
      ..write(obj.cognome)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.nome)
      ..writeByte(4)
      ..write(obj.saldo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
