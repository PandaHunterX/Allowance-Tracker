import 'package:flutter/material.dart';

class CustomizeButton extends StatelessWidget {
  const CustomizeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade800, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(32))),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            size: 40,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Add New Expenses',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
