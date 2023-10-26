import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:solana/solana.dart';
import 'package:web3_login/services/fetch_profile.dart';
import 'package:web3_login/services/write_profile.dart';

import 'package:web3_login/widgets/send_dialog.dart';

import '../anchor_types/profile_parameters.dart';
import '../widgets/nft_list.dart';
import '../widgets/token_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _publicKey;
  String? _balance;
  SolanaClient? client;
  final storage = const FlutterSecureStorage();
  String CID = '';
  String name = '';
  String symbol = '';
  bool newFetch = false;

  bool _showNftExpanded = false;
  bool _showTokensExpanded = false;

  Profile? profile;

  @override
  void initState() {
    super.initState();
    _readPk();
  }

  void _readProfile() async {
    if (client != null) {
      profile = await fetch_profile(client!);
      if (!mounted) return;
      setState(() {});
    }
  }

  ImageProvider _getAvatar() {
    if (profile != null) {
      return NetworkImage(profile!.uri);
    }
    return AssetImage('assets/default_avatar.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.tealAccent.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                GoRouter.of(context).go(
                  '/profilePage',
                  extra: profile,
                );
              },
              child: CircleAvatar(
                backgroundImage: _getAvatar(),
                backgroundColor: Colors.grey[200],
              ),
            ),
            profile == null ? Text("My wallet") : Text(profile!.nickname),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                GoRouter.of(context).go("/config");
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Text('Wallet Address',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            _publicKey ?? 'Loading...',
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            if (_publicKey != null) {
                              Clipboard.setData(
                                  ClipboardData(text: _publicKey!));
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Text('Balance',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            SendDialog(context, "Solana", null);
                          },
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/Solana.png'),
                              ),
                              Text(
                                _balance ?? 'Loading...',
                                style: const TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            _getBalance();
                          },
                        ),
                        IconButton(
                          icon: Icon(_showTokensExpanded
                              ? Icons.expand_less
                              : Icons.expand_more),
                          onPressed: () {
                            setState(() {
                              _showTokensExpanded = !_showTokensExpanded;
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_showTokensExpanded && client != null)
              TokenList(publicKey: _publicKey, client: client!),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mint NFT',
                      style: TextStyle(fontSize: 17),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        GoRouter.of(context).go('/createNft', extra: client);
                      },
                    )
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create Token',
                      style: TextStyle(fontSize: 17),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        GoRouter.of(context).go('/createToken', extra: client);
                      },
                    )
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Show Wallet NFTs',
                      style: TextStyle(fontSize: 17),
                    ),
                    IconButton(
                      icon: Icon(_showNftExpanded
                          ? Icons.expand_less
                          : Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _showNftExpanded = !_showNftExpanded;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            if (_showNftExpanded)
              NftList(
                publicKey: _publicKey,
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Log out',
                      style: TextStyle(fontSize: 17),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        GoRouter.of(context).go("/");
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _readPk() async {
    final mnemonic = await storage.read(key: 'mnemonic');
    if (mnemonic != null) {
      final keypair = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
      setState(() {
        _publicKey = keypair.address;
      });
      _initializeClient();
    }
  }

  void _initializeClient() async {
    String? rpcUrl;
    final network = await storage.read(key: "network");
    if (network == null || network == "") {
      await storage.write(key: 'network', value: "mainnet");
      rpcUrl = "https://api.mainnet-beta.solana.com";
      await storage.write(key: 'mainnetRpc', value: rpcUrl);
    } else if (network == "mainnet") {
      rpcUrl = await storage.read(key: "mainnetRpc");
    } else if (network == "devnet") {
      rpcUrl = await storage.read(key: "devnetRpc");
    }

    String wsUrl = rpcUrl!.replaceFirst('https', 'wss');
    client = SolanaClient(
      rpcUrl: Uri.parse(rpcUrl),
      websocketUrl: Uri.parse(wsUrl),
    );

    _readProfile();
    _getBalance();
  }

  void _getBalance() async {
    setState(() {
      _balance = null;
    });
    final getBalance = await client?.rpcClient
        .getBalance(_publicKey!, commitment: Commitment.confirmed);
    final balance = (getBalance!.value) / lamportsPerSol;
    setState(() {
      _balance = balance.toString();
    });
  }
}
