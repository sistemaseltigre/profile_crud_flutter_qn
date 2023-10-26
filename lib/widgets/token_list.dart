import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web3_login/models/Token.dart';
import 'package:web3_login/widgets/send_dialog.dart';
import '../services/fetch_tokens.dart';

import 'package:solana/solana.dart' as solana;

class TokenList extends StatefulWidget {
  final solana.SolanaClient client;
  final String? publicKey;

  TokenList({
    Key? key,
    required this.publicKey,
    required this.client,
  }) : super(key: key);

  @override
  _NftListState createState() => _NftListState();
}

class _NftListState extends State<TokenList> {
  Future<List<Token>>? _tokenFuture;

  @override
  void initState() {
    super.initState();
    _loadNfts();
  }

  Future<void> _loadNfts() async {
    if (widget.publicKey != null) {
      _tokenFuture = fetch_tokens(widget.client, widget.publicKey!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
            height: 200,
            child: FutureBuilder<List<Token>>(
                future: _tokenFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final tokens = snapshot.data;
                    return ListView.builder(
                        itemCount: (tokens?.length ?? 0) + 1,
                        itemBuilder: (context, index) {
                          if (tokens == null) {
                            return IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                _loadNfts();
                              },
                            );
                          }
                          if (index < tokens.length) {
                            final token = tokens[index];
                            return ListTile(
                              onTap: () {
                                SendDialog(context, token.symbol!, token);
                              },
                              title: Text(token.name ?? ""),
                              subtitle: Text(token.symbol ?? ""),
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(token.uri ??
                                      "https://placehold.co/100x100/png")),
                              trailing: Text(token.balance.toString()),
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                setState(() {
                                  _tokenFuture = fetch_tokens(
                                      widget.client, widget.publicKey!);
                                });
                              },
                            );
                          }
                        });
                  }
                })));
  }
}
