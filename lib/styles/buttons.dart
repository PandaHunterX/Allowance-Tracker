import 'package:flutter/material.dart';

class CustomizeButton extends StatelessWidget {
  final IconData icon;
  final String text;
  const CustomizeButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade800, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(32))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
