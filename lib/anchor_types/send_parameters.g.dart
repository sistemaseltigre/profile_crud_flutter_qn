// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_parameters.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$ProfileSend {
  String get nickname => throw UnimplementedError();
  String get description => throw UnimplementedError();
  String get uri => throw UnimplementedError();
  BigInt get level => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BString().write(writer, nickname);
    const BString().write(writer, description);
    const BString().write(writer, uri);
    const BU64().write(writer, level);

    return writer.toArray();
  }
}

class _ProfileSend extends ProfileSend {
  _ProfileSend({
    required this.nickname,
    required this.description,
    required this.uri,
    required this.level,
  }) : super._();

  final String nickname;
  final String description;
  final String uri;
  final BigInt level;
}

class BProfileSend implements BType<ProfileSend> {
  const BProfileSend();

  @override
  void write(BinaryWriter writer, ProfileSend value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  ProfileSend read(BinaryReader reader) {
    return ProfileSend(
      nickname: const BString().read(reader),
      description: const BString().read(reader),
      uri: const BString().read(reader),
      level: const BU64().read(reader),
    );
  }
}

ProfileSend _$ProfileSendFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BProfileSend().read(reader);
}
