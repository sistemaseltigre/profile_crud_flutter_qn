import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/NFT.dart';
import '../services/nft_api.dart';

class NftList extends StatefulWidget {
  final String? publicKey;

  const NftList({
    Key? key,
    required this.publicKey,
  }) : super(key: key);

  @override
  _NftListState createState() => _NftListState();
}

class _NftListState extends State<NftList> {
  Future<List<NFT>>? _nftsFuture;

  @override
  void initState() {
    super.initState();
    _loadNfts();
  }

  Future<void> _loadNfts() async {
    if (widget.publicKey != null) {
      _nftsFuture = fetchNfts(widget.publicKey!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
            height: 200,
            child: FutureBuilder<List<NFT>>(
                future: _nftsFuture,
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
                    final nfts = snapshot.data;
                    return ListView.builder(
                        itemCount: (nfts?.length ?? 0) + 1,
                        itemBuilder: (context, index) {
                          if (nfts == null) {
                            return IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                _loadNfts();
                              },
                            );
                          }
                          if (index < nfts.length) {
                            final nft = nfts[index];
                            return ListTile(
                              onTap: () {
                                GoRouter.of(context).go('/showNft', extra: nft);
                              },
                              title: Text(nft.name ?? ""),
                              subtitle: Text(nft.description ?? ""),
                              leading: Image.network(nft.imageUrl ??
                                  "https://placehold.co/600x400/png"),
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                setState(() {
                                  _nftsFuture = fetchNfts(widget.publicKey!);
                                });
                              },
                            );
                          }
                        });
                  }
                })));
  }
}
