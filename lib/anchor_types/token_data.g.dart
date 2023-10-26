// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_data.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$TokenData {
  int get mint_authority_option => throw UnimplementedError();
  Ed25519HDPublicKey get mint_authority => throw UnimplementedError();
  BigInt get supply => throw UnimplementedError();
  int get decimals => throw UnimplementedError();
  bool get is_initialized => throw UnimplementedError();
  int get freeze_authority_option => throw UnimplementedError();
  Ed25519HDPublicKey get freezeAuthority => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU32().write(writer, mint_authority_option);
    const BPublicKey().write(writer, mint_authority);
    const BU64().write(writer, supply);
    const BU8().write(writer, decimals);
    const BBool().write(writer, is_initialized);
    const BU32().write(writer, freeze_authority_option);
    const BPublicKey().write(writer, freezeAuthority);

    return writer.toArray();
  }
}

class _TokenData extends TokenData {
  _TokenData({
    required this.mint_authority_option,
    required this.mint_authority,
    required this.supply,
    required this.decimals,
    required this.is_initialized,
    required this.freeze_authority_option,
    required this.freezeAuthority,
  }) : super._();

  final int mint_authority_option;
  final Ed25519HDPublicKey mint_authority;
  final BigInt supply;
  final int decimals;
  final bool is_initialized;
  final int freeze_authority_option;
  final Ed25519HDPublicKey freezeAuthority;
}

class BTokenData implements BType<TokenData> {
  const BTokenData();

  @override
  void write(BinaryWriter writer, TokenData value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  TokenData read(BinaryReader reader) {
    return TokenData(
      mint_authority_option: const BU32().read(reader),
      mint_authority: const BPublicKey().read(reader),
      supply: const BU64().read(reader),
      decimals: const BU8().read(reader),
      is_initialized: const BBool().read(reader),
      freeze_authority_option: const BU32().read(reader),
      freezeAuthority: const BPublicKey().read(reader),
    );
  }
}

TokenData _$TokenDataFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BTokenData().read(reader);
}
