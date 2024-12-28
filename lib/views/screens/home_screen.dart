import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:productivity_app/controllers/new_expense.dart';
import 'package:productivity_app/styles/buttons.dart';
import 'package:productivity_app/views/widgets/expenses_list.dart';
import 'package:productivity_app/views/widgets/user_allowance.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 54,
              decoration: BoxDecoration(
                border: Border.all(width: 4, color: Colors.blue.shade900),
                borderRadius: const BorderRadius.all(Radius.circular(32)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Your Allowance',
                      style: TextStyle(fontSize: 36),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/svg/money.svg'),
                        const SizedBox(
                          width: 8,
                        ),
                        UserAllowance(key: UniqueKey(),),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => NewExpense(onExpenseAdded: _refresh),
                  ),
                );
              },
              child: const CustomizeButton(text: 'Add New Expense', icon: Icons.add,),
            ),
            const SizedBox(height: 32),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal:
                  BorderSide(width: 4.0, color: Colors.blue.shade900),
                  vertical: BorderSide.none,
                ),
              ),
              child: const Text(
                'Your Expenses Today',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 8,),
            ExpensesList(key: UniqueKey()),
          ],
        ),
      ),
    );
  }
}