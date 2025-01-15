import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  final BuildContext ctx;

  const Help({required this.ctx, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'FAQs',
        style: TextStyle(fontSize: 24),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/help.png',
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "How to Edit an Item?",
            style: TextStyle(
              fontSize: MediaQuery.sizeOf(context).width < 412? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Simply double-tap on an item to edit any fields you'd like.",
            style: TextStyle(
              fontSize:  MediaQuery.sizeOf(context).width < 412? 16 : 20,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "How to Delete an Item?",
            style: TextStyle(
              fontSize: MediaQuery.sizeOf(context).width < 412? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Long press on an item and then tap 'Yes' to delete.",
            style: TextStyle(
              fontSize: MediaQuery.sizeOf(context).width < 412? 16 : 20,
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
            'Thank you',
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
