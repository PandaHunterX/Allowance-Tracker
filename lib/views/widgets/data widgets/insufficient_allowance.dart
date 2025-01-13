import 'package:flutter/material.dart';

class InsufficientAllowance extends StatelessWidget {
  final BuildContext ctx;

  const InsufficientAllowance({
    super.key,
    required this.ctx,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insufficient Allowance'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/insufficient-allowance.png',
            width: MediaQuery.sizeOf(context).width * 0.5,
          ),
          SizedBox(
            height: 16,
          ),
          const Text(
            "You don't have enough allowance!",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue[100])),
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text(
            'Ok',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
