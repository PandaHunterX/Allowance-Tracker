import 'package:flutter/material.dart';
import 'package:productivity_app/styles/text_style.dart';

class ExpenseEmptyList extends StatelessWidget {
  const ExpenseEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          Image.asset(
            'assets/images/no_money.png',
            width: MediaQuery.of(context).size.width - 64,
            height: MediaQuery.of(context).size.height * .2,
          ),
          const SizedBox(
            height: 8,
          ),
          const SecondaryText(
              words: "YOU DIDN'T SPEND ANYTHING TODAY",
              size: 24,
              maxLines: 1,
          ),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/no_allowance.png',
                width: MediaQuery.of(context).size.width - 64,
                height: MediaQuery.of(context).size.height * .2,
              ),
              const SecondaryText(
                words: "YOU HAVE NO ALLOWANCE YET",
                size: 24,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
