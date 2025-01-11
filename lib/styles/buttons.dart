import 'package:flutter/material.dart';
import 'package:productivity_app/styles/textstyle.dart';

class CustomizeButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const CustomizeButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade800, width: 5),
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
          TitleText(words: text, size: 20, fontWeight: FontWeight.w800)
        ],
      ),
    );
  }
}
