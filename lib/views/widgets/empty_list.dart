import 'package:flutter/material.dart';

class ExpenseEmptyList extends StatelessWidget {
  const ExpenseEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          Image.asset(
            'assets/images/no_money.png',
            width: MediaQuery.of(context).size.width - 64,
            height: MediaQuery.of(context).size.height * .25,
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "YOU DIDN'T SPEND ANYTHING TODAY",
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}

class AllowanceEmptyList extends StatelessWidget {
  const AllowanceEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/no_allowance.png',
              width: MediaQuery.of(context).size.width - 64,
              height: MediaQuery.of(context).size.height * .25,
            ),
            const Text(
              "YOU HAVE NO ALLOWANCE YET",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
