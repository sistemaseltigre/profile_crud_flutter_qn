import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:solana/solana.dart' as solana;
import 'package:solana_common/utils/buffer.dart' as solana_buffer;
import 'package:solana/anchor.dart' as solana_anchor;
import 'package:solana/encoder.dart' as solana_encoder;

Future<String> DeleteProfile() async {
  final storage = FlutterSecureStorage();
  final mainWalletKey = await storage.read(key: 'mnemonic');
  final mainWalletSolana = await solana.Ed25519HDKeyPair.fromMnemonic(
    mainWalletKey!,
  );
  String? rpcUrl;
  final network = await storage.read(key: "network");

  if (network == "mainnet") {
    rpcUrl = await storage.read(key: "mainnetRpc");
  } else if (network == "devnet") {
    rpcUrl = await storage.read(key: "devnetRpc");
  }

  String wsUrl = rpcUrl!.replaceFirst('https', 'wss');
  final client = solana.SolanaClient(
    rpcUrl: Uri.parse(rpcUrl),
    websocketUrl: Uri.parse(wsUrl),
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
  final systemProgramId =
      solana.Ed25519HDPublicKey.fromBase58(solana.SystemProgram.programId);

  final instruction = await solana_anchor.AnchorInstruction.forMethod(
    programId: programIdPublicKey,
    method: "deleteprofile",
    arguments: const solana_encoder.ByteArray.empty(),
    accounts: <solana_encoder.AccountMeta>[
      solana_encoder.AccountMeta.writeable(pubKey: profilePda, isSigner: false),
      solana_encoder.AccountMeta.writeable(
          pubKey: mainWalletSolana.publicKey, isSigner: true),
      solana_encoder.AccountMeta.readonly(
          pubKey: systemProgramId, isSigner: false),
    ],
    namespace: 'global',
  );

  final message = solana.Message(instructions: [instruction]);
  final signature = await client.sendAndConfirmTransaction(
    message: message,
    signers: [mainWalletSolana],
    commitment: solana.Commitment.confirmed,
  );

  return signature;
}
