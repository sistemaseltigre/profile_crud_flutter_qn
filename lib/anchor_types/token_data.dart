import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/solana.dart';

part 'token_data.g.dart';

@BorshSerializable()
class TokenData with _$TokenData {
  factory TokenData({
    @BU32() required int mint_authority_option,
    @BPublicKey() required Ed25519HDPublicKey mint_authority,
    @BU64() required BigInt supply,
    @BU8() required int decimals,
    @BBool() required bool is_initialized,
    @BU32() required int freeze_authority_option,
    @BPublicKey() required Ed25519HDPublicKey freezeAuthority,
  }) = _TokenData;

  const TokenData._();

  factory TokenData.fromBorsh(Uint8List data) => _$TokenDataFromBorsh(data);
}
