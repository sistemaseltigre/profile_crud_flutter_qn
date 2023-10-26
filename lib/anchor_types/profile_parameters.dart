import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/solana.dart';

part 'profile_parameters.g.dart';

@BorshSerializable()
class Profile with _$Profile {
  factory Profile({
    @BU64() required BigInt deterministicId,
    @BU64() required BigInt level,
    @BString() required String nickname,
    @BString() required String description,
    @BString() required String uri,
    @BPublicKey() required Ed25519HDPublicKey owner,
  }) = _Profile;

  const Profile._();

  factory Profile.fromBorsh(Uint8List data) => _$ProfileFromBorsh(data);
}
