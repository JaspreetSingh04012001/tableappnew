// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddOnAdapter extends TypeAdapter<AddOn> {
  @override
  final int typeId = 2;

  @override
  AddOn read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddOn(
      id: fields[0] as int?,
      name: fields[1] as String?,
      price: fields[2] as double?,
      quantity: fields[3] as int?,
      tax: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, AddOn obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.tax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddOnAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryIdAdapter extends TypeAdapter<CategoryId> {
  @override
  final int typeId = 3;

  @override
  CategoryId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryId(
      id: fields[0] as String?,
      position: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryId obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChoiceOptionAdapter extends TypeAdapter<ChoiceOption> {
  @override
  final int typeId = 4;

  @override
  ChoiceOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChoiceOption(
      name: fields[0] as String?,
      title: fields[1] as String?,
      options: (fields[2] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChoiceOption obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChoiceOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VariationAdapter extends TypeAdapter<Variation> {
  @override
  final int typeId = 1;

  @override
  Variation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Variation(
      name: fields[0] as String?,
      min: fields[1] as int?,
      max: fields[2] as int?,
      isRequired: fields[3] as bool?,
      variationValues: (fields[5] as List?)?.cast<VariationValue>(),
      isMultiSelect: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Variation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.min)
      ..writeByte(2)
      ..write(obj.max)
      ..writeByte(3)
      ..write(obj.isRequired)
      ..writeByte(4)
      ..write(obj.isMultiSelect)
      ..writeByte(5)
      ..write(obj.variationValues);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VariationValueAdapter extends TypeAdapter<VariationValue> {
  @override
  final int typeId = 5;

  @override
  VariationValue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VariationValue(
      level: fields[0] as String?,
      optionPrice: fields[1] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, VariationValue obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.optionPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariationValueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BranchProductAdapter extends TypeAdapter<BranchProduct> {
  @override
  final int typeId = 6;

  @override
  BranchProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BranchProduct(
      id: fields[0] as int?,
      productId: fields[1] as int?,
      branchId: fields[2] as int?,
      isAvailable: fields[3] as bool?,
      variations: (fields[4] as List?)?.cast<Variation>(),
      price: fields[5] as double?,
      discountType: fields[7] as String?,
      discount: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, BranchProduct obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.branchId)
      ..writeByte(3)
      ..write(obj.isAvailable)
      ..writeByte(4)
      ..write(obj.variations)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.discount)
      ..writeByte(7)
      ..write(obj.discountType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BranchProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
