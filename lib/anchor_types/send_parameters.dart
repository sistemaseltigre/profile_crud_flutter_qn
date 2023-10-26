import 'package:borsh_annotation/borsh_annotation.dart';

part 'send_parameters.g.dart';

@BorshSerializable()
class ProfileSend with _$ProfileSend {
  factory ProfileSend({
    @BString() required String nickname,
    @BString() required String description,
    @BString() required String uri,
    @BU64() required BigInt level,
  }) = _ProfileSend;

  const ProfileSend._();

  factory ProfileSend.fromBorsh(Uint8List data) => _$ProfileSendFromBorsh(data);
}
