import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:solana/dto.dart';
import 'package:solana/metaplex.dart';
import 'package:solana/solana.dart' as solana;
import 'package:solana_common/utils/buffer.dart' as solana_buffer;
import 'package:web3_login/anchor_types/token_data.dart';

import '../anchor_types/ata_data.dart';
import '../models/Token.dart';

Future<List<Token>> fetch_tokens(
    solana.SolanaClient? client, String? pubkey) async {
  print("fetching tokens");
  List<Token> tokenList = [];
  if (client == null || pubkey == null) {
    return tokenList;
  }
  final ataList = await client!.rpcClient
      .getTokenAccountsByOwner(
        pubkey!,
        TokenAccountsFilter.byProgramId(solana.TokenProgram.programId),
        encoding: Encoding.base64,
        commitment: Commitment.confirmed,
      )
      .value;

  for (var ata in ataList) {
    final ataBytes = ata.account.data as BinaryAccountData;
    final ataData = AtaData.fromBorsh(ataBytes.data as Uint8List);
    final mintInfo = await client.rpcClient
        .getAccountInfo(
          ataData.mint.toString(),
          commitment: Commitment.confirmed,
          encoding: Encoding.base64,
        )
        .value;
    final mintBytes = mintInfo?.data as BinaryAccountData;
    final mintData = TokenData.fromBorsh(mintBytes.data as Uint8List);
    if (mintData.decimals > 0) {
      Token token = Token();
      final balance =
          await client.rpcClient.getTokenAccountBalance(ata.pubkey).value;

      token.balance = double.tryParse(balance.uiAmountString!);
      token.decimals = mintData.decimals;
      token.tokenAddress = ataData.mint.toString();
      if (token.balance! > 0) {
        const metaplexProgramId = 'metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s';
        final metaplexProgramIdPublicKey =
            solana.Ed25519HDPublicKey.fromBase58(metaplexProgramId);
        final metadataPda = await solana.Ed25519HDPublicKey.findProgramAddress(
          seeds: [
            solana_buffer.Buffer.fromString("metadata"),
            metaplexProgramIdPublicKey.bytes,
            ataData.mint.bytes,
          ],
          programId: metaplexProgramIdPublicKey,
        );
        final metadataPdaInfo = await client.rpcClient
            .getAccountInfo(
              metadataPda.toString(),
              commitment: Commitment.confirmed,
              encoding: Encoding.base64,
            )
            .value;
        if (metadataPdaInfo != null) {
          final metadataPdaBytes = metadataPdaInfo.data as BinaryAccountData;

          final metadata =
              Metadata.fromBinary(metadataPdaBytes.data as Uint8List);
          token.name = metadata.name;
          token.symbol = metadata.symbol;
          var response = await http.get(Uri.parse(metadata.uri));
          var jsonData = jsonDecode(response.body);
          token.uri = jsonData['image'];

          tokenList.add(token);
        }
      }
    }
  }

  return tokenList;
}
