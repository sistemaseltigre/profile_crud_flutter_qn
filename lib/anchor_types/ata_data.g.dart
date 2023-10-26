// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ata_data.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$AtaData {
  Ed25519HDPublicKey get mint => throw UnimplementedError();
  Ed25519HDPublicKey get owner => throw UnimplementedError();
  BigInt get amount => throw UnimplementedError();
  int get delegateOption => throw UnimplementedError();
  Ed25519HDPublicKey get delegate => throw UnimplementedError();
  int get state => throw UnimplementedError();
  int get isNativeOption => throw UnimplementedError();
  BigInt get isNative => throw UnimplementedError();
  BigInt get delegatedAmount => throw UnimplementedError();
  int get closeAuthorityOption => throw UnimplementedError();
  Ed25519HDPublicKey get closeAuthority => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BPublicKey().write(writer, mint);
    const BPublicKey().write(writer, owner);
    const BU64().write(writer, amount);
    const BU32().write(writer, delegateOption);
    const BPublicKey().write(writer, delegate);
    const BU8().write(writer, state);
    const BU32().write(writer, isNativeOption);
    const BU64().write(writer, isNative);
    const BU64().write(writer, delegatedAmount);
    const BU32().write(writer, closeAuthorityOption);
    const BPublicKey().write(writer, closeAuthority);

    return writer.toArray();
  }
}

class _AtaData extends AtaData {
  _AtaData({
    required this.mint,
    required this.owner,
    required this.amount,
    required this.delegateOption,
    required this.delegate,
    required this.state,
    required this.isNativeOption,
    required this.isNative,
    required this.delegatedAmount,
    required this.closeAuthorityOption,
    required this.closeAuthority,
  }) : super._();

  final Ed25519HDPublicKey mint;
  final Ed25519HDPublicKey owner;
  final BigInt amount;
  final int delegateOption;
  final Ed25519HDPublicKey delegate;
  final int state;
  final int isNativeOption;
  final BigInt isNative;
  final BigInt delegatedAmount;
  final int closeAuthorityOption;
  final Ed25519HDPublicKey closeAuthority;
}

class BAtaData implements BType<AtaData> {
  const BAtaData();

  @override
  void write(BinaryWriter writer, AtaData value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  AtaData read(BinaryReader reader) {
    return AtaData(
      mint: const BPublicKey().read(reader),
      owner: const BPublicKey().read(reader),
      amount: const BU64().read(reader),
      delegateOption: const BU32().read(reader),
      delegate: const BPublicKey().read(reader),
      state: const BU8().read(reader),
      isNativeOption: const BU32().read(reader),
      isNative: const BU64().read(reader),
      delegatedAmount: const BU64().read(reader),
      closeAuthorityOption: const BU32().read(reader),
      closeAuthority: const BPublicKey().read(reader),
    );
  }
}

AtaData _$AtaDataFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BAtaData().read(reader);
}
