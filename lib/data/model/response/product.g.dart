// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as int?,
      name: fields[1] as String?,
      description: fields[2] as String?,
      image: fields[3] as String?,
      price: fields[4] as double?,
      variations: (fields[5] as List?)?.cast<Variation>(),
      addOns: (fields[6] as List?)?.cast<AddOn>(),
      tax: fields[7] as double?,
      availableTimeStarts: fields[8] as String?,
      availableTimeEnds: fields[9] as String?,
      status: fields[10] as int?,
      createdAt: fields[11] as DateTime?,
      updatedAt: fields[12] as DateTime?,
      attributes: (fields[13] as List?)?.cast<String>(),
      categoryIds: (fields[14] as List?)?.cast<CategoryId>(),
      choiceOptions: (fields[15] as List?)?.cast<ChoiceOption>(),
      discount: fields[16] as double?,
      discountType: fields[17] as String?,
      taxType: fields[18] as String?,
      setMenu: fields[19] as int?,
      popularityCount: fields[20] as int?,
      rating: (fields[21] as List?)?.cast<Rating>(),
      productType: fields[22] as String?,
      branchProduct: fields[23] as BranchProduct?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.variations)
      ..writeByte(6)
      ..write(obj.addOns)
      ..writeByte(7)
      ..write(obj.tax)
      ..writeByte(8)
      ..write(obj.availableTimeStarts)
      ..writeByte(9)
      ..write(obj.availableTimeEnds)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.attributes)
      ..writeByte(14)
      ..write(obj.categoryIds)
      ..writeByte(15)
      ..write(obj.choiceOptions)
      ..writeByte(16)
      ..write(obj.discount)
      ..writeByte(17)
      ..write(obj.discountType)
      ..writeByte(18)
      ..write(obj.taxType)
      ..writeByte(19)
      ..write(obj.setMenu)
      ..writeByte(20)
      ..write(obj.popularityCount)
      ..writeByte(21)
      ..write(obj.rating)
      ..writeByte(22)
      ..write(obj.productType)
      ..writeByte(23)
      ..write(obj.branchProduct);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
