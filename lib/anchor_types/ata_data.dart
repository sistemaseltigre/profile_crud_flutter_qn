import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/solana.dart';

part 'ata_data.g.dart';

@BorshSerializable()
class AtaData with _$AtaData {
  factory AtaData({
    @BPublicKey() required Ed25519HDPublicKey mint,
    @BPublicKey() required Ed25519HDPublicKey owner,
    @BU64() required BigInt amount,
    @BU32() required int delegateOption,
    @BPublicKey() required Ed25519HDPublicKey delegate,
    @BU8() required int state,
    @BU32() required int isNativeOption,
    @BU64() required BigInt isNative,
    @BU64() required BigInt delegatedAmount,
    @BU32() required int closeAuthorityOption,
    @BPublicKey() required Ed25519HDPublicKey closeAuthority,
  }) = _AtaData;

  const AtaData._();

  factory AtaData.fromBorsh(Uint8List data) => _$AtaDataFromBorsh(data);
}
