// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piatto_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PiattoEntityAdapter extends TypeAdapter<PiattoEntity> {
  @override
  final int typeId = 3;

  @override
  PiattoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PiattoEntity(
      allergeni: fields[0] as String?,
      categoria: fields[1] as String?,
      costoBase: fields[2] as double?,
      descrizione: fields[3] as String?,
      nome: fields[4] as String?,
      piattoId: fields[5] as int?,
      tipo: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PiattoEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.allergeni)
      ..writeByte(1)
      ..write(obj.categoria)
      ..writeByte(2)
      ..write(obj.costoBase)
      ..writeByte(3)
      ..write(obj.descrizione)
      ..writeByte(4)
      ..write(obj.nome)
      ..writeByte(5)
      ..write(obj.piattoId)
      ..writeByte(6)
      ..write(obj.tipo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PiattoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
