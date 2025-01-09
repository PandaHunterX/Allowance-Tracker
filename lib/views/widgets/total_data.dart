import 'package:flutter/material.dart';
import 'package:productivity_app/database/finance_db.dart';

class TotalData extends StatelessWidget {
  TotalData({super.key});

  final db = FinanceDB();

  Future<Map<String, double>> _fetchData() async {
    final expenses = await db.fetchExpense();
    final allowance = await db.fetchAllowance();
    double totalExpenses = expenses.fold(0, (sum, item) => sum + item.expense);
    double totalAllowance = allowance.fold(0, (sum, item) => sum + item.amount);
    return {
      'totalAllowance': totalAllowance,
      'totalExpenses': totalExpenses,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else {
          final data = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your History'),
              SizedBox(height: 16,),
              Text('Total Allowance: Php ${data['totalAllowance']}'),
              Text('Total Expenses: Php ${data['totalExpenses']}'),
            ],
          );
        }
      },
    );
  }
}