import 'package:flutter/material.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/styles/textstyle.dart';

class TotalData extends StatelessWidget {
  TotalData({super.key});

  final db = FinanceDB();

  Future<Map<String, dynamic>> _fetchData() async {
    final expenses = await db.fetchExpense();
    final allowance = await db.fetchAllowance();
    final user = await db.fetchUser();
    double totalExpenses = expenses.fold(0, (sum, item) => sum + item.expense);
    double totalAllowance = allowance.fold(0, (sum, item) => sum + item.amount);
    return {
      'totalAllowance': totalAllowance,
      'totalExpenses': totalExpenses,
      'user': user,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else {
          final data = snapshot.data!;
          final user = data['user'];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleText(words: 'Your Overall Data', size: 32, fontWeight: FontWeight.w800,),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleText(words: 'Total Allowance:', size: 24, fontWeight: FontWeight.w700),
                  SizedBox(width: 8,),
                  Text('${user.currency} ', style: TextStyle(fontSize: 24),),
                  SecondaryText(words: '${data['totalAllowance']}', size: 24, maxLines: 1),
                ],
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleText(words: 'Total Expenses:', size: 24, fontWeight: FontWeight.w700),
                  SizedBox(width: 8,),
                  Text('${user.currency} ', style: TextStyle(fontSize: 24),),
                  SecondaryText(words: '${data['totalExpenses']}', size: 24, maxLines: 1),
                ],
              ),
            ],
          );
        }
      },
    );
  } //
}