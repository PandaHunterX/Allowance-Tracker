import 'package:flutter/material.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/allowance_item.dart';
import 'package:productivity_app/models/expense_item.dart';
import 'package:intl/intl.dart';

class RecentDataList extends StatefulWidget {
  final String searchQuery;

  const RecentDataList({super.key, required this.searchQuery});

  @override
  State<RecentDataList> createState() => _RecentDataListState();
}

class _RecentDataListState extends State<RecentDataList> {
  List<dynamic> recentData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentData();
  }

  Future<void> _fetchRecentData() async {
    final db = FinanceDB();
    final fetchedAllowances = await db.fetchAllowance();
    final fetchedExpenses = await db.fetchExpense();

    setState(() {
      recentData = [...fetchedAllowances, ...fetchedExpenses];
      recentData.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredData = recentData.where((item) {
      if (item is AllowanceItem) {
        return item.description.contains(widget.searchQuery);
      } else if (item is ExpenseItem) {
        return item.name.contains(widget.searchQuery);
      }
      return false;
    }).toList();

    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (ctx, index) {
        final item = filteredData[index];
        if (item is AllowanceItem) {
          return ListTile(
            textColor: Colors.green.shade900,
            title: Row(
              children: [
                item.category.icon,
                SizedBox(width: 4,),
                Text('Allowance: ${item.description}'),
              ],
            ),
            subtitle: Text('Amount: ++ Php ${item.amount}'),
            trailing: Text(DateFormat.yMMMd().format(item.dateTime)),
          );
        } else if (item is ExpenseItem) {
          return ListTile(
            textColor: Colors.red.shade900,
            title: Row(
              children: [
                item.category.icon,
                SizedBox(width: 4,),
                Text('Expense: ${item.name}'),
              ],
            ),
            subtitle: Text('Amount: -- Php ${item.expense}'),
            trailing: Text(DateFormat.yMMMd().format(item.dateTime)),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}