import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          Image.asset('assets/images/no_money.png', width: MediaQuery.of(context).size.width - 64, height: MediaQuery.of(context).size.height *.2,),
          const SizedBox(height: 8,),
          const Text("YOU DIDN'T SPEND ANYTHING TODAY", style: TextStyle(fontSize: 20),)
        ],
      ),
    );
  }
}
