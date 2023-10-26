import 'dart:developer';

import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart' as solana;
import 'package:solana_common/utils/buffer.dart' as solana_buffer;

import '../anchor_types/profile_parameters.dart';

Future<Profile?> fetch_profile(solana.SolanaClient client) async {
  const storage = FlutterSecureStorage();

  final mainWalletKey = await storage.read(key: 'mnemonic');

  final mainWalletSolana = await solana.Ed25519HDKeyPair.fromMnemonic(
    mainWalletKey!,
  );
  final programIdPublicKey = solana.Ed25519HDPublicKey.fromBase58(
      "HFMCvkxw8mLvYkS8SvvrEoNghP3AyH6BGFkCi5dzB9Fk");

  final profilePda = await solana.Ed25519HDPublicKey.findProgramAddress(
    seeds: [
      solana_buffer.Buffer.fromString("qprofile"),
      mainWalletSolana.publicKey.bytes,
    ],
    programId: programIdPublicKey,
  );
  final result = await client.rpcClient
      .getAccountInfo(
        profilePda.toBase58(),
        commitment: solana.Commitment.confirmed,
        encoding: Encoding.jsonParsed,
      )
      .value;
  inspect(result);
  if (result == null) {
    return null;
  } else {
    final bytes = ((result.data as BinaryAccountData).data);
    final decodedProfile = Profile.fromBorsh(bytes as Uint8List);
    inspect(decodedProfile);

    return decodedProfile;
  }
}
