// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_parameters.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$Profile {
  BigInt get deterministicId => throw UnimplementedError();
  BigInt get level => throw UnimplementedError();
  String get nickname => throw UnimplementedError();
  String get description => throw UnimplementedError();
  String get uri => throw UnimplementedError();
  Ed25519HDPublicKey get owner => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, deterministicId);
    const BU64().write(writer, level);
    const BString().write(writer, nickname);
    const BString().write(writer, description);
    const BString().write(writer, uri);
    const BPublicKey().write(writer, owner);

    return writer.toArray();
  }
}

class _Profile extends Profile {
  _Profile({
    required this.deterministicId,
    required this.level,
    required this.nickname,
    required this.description,
    required this.uri,
    required this.owner,
  }) : super._();

  final BigInt deterministicId;
  final BigInt level;
  final String nickname;
  final String description;
  final String uri;
  final Ed25519HDPublicKey owner;
}

class BProfile implements BType<Profile> {
  const BProfile();

  @override
  void write(BinaryWriter writer, Profile value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  Profile read(BinaryReader reader) {
    return Profile(
      deterministicId: const BU64().read(reader),
      level: const BU64().read(reader),
      nickname: const BString().read(reader),
      description: const BString().read(reader),
      uri: const BString().read(reader),
      owner: const BPublicKey().read(reader),
    );
  }
}

Profile _$ProfileFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BProfile().read(reader);
}
