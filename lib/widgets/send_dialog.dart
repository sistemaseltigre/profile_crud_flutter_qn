import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/Token.dart';
import '../services/send_sol.dart';
import '../services/send_token.dart';

Future<void> SendDialog(BuildContext context, String coin, Token? token) async {
  TextEditingController destinationController = TextEditingController();
  TextEditingController ammountController = TextEditingController();
  String address;
  double amount;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Send $coin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Enter Destination Wallet'),
              controller: destinationController,
              onChanged: (value) {},
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Enter Ammount'),
              controller: ammountController,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Send'),
            onPressed: () async {
              address = destinationController.text;
              amount = double.parse(ammountController.text);
              String message = '';
              if (token == null) {
                message = await send_sol(address, amount);
              } else {
                message = await send_token(message = token.tokenAddress!,
                    address, amount, token.decimals!);
              }
              _resultDialog(context, message);
            },
          ),
        ],
      );
    },
  );
}

void _resultDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Success'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Transaction successful with result ",
            ),
            Text(message),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Accept'),
            onPressed: () {
              Navigator.pop(context);
              context.pushReplacement("/home");
            },
          ),
        ],
      );
    },
  );
}
