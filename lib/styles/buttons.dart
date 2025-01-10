import 'package:auto_size_text/auto_size_text.dart';
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
        borderRadius: const BorderRadius.all(Radius.circular(32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: MediaQuery.sizeOf(context).height * .03,
          ),
          const SizedBox(
            width: 8,
          ),
          AutoSizeText(
            maxLines: 1,
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
