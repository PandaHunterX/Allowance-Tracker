import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/expense_item.dart';
import 'package:productivity_app/views/widgets/empty_list.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({super.key});

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  List<ExpenseItem> expenses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    final db = FinanceDB();
    final fetchedExpenses = await db.fetchAll();
    setState(() {
      expenses = fetchedExpenses;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final today = DateTime.now();
    final todayExpenses = expenses.where((item) {
      return item.dateTime.year == today.year &&
          item.dateTime.month == today.month &&
          item.dateTime.day == today.day;
    }).toList();

    var content = (todayExpenses.isNotEmpty)
        ? ExpenseList(todayExpenses: todayExpenses)
        : const EmptyList();

    return content;
  }
}

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.todayExpenses,
  });

  final List<ExpenseItem> todayExpenses;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
              "Total Expenses: Php ${todayExpenses.fold(0.0, (sum, item) => sum + item.expense)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          Expanded(
            child: ListView.builder(
              itemCount: todayExpenses.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Row(
                  children: [
                    todayExpenses[index].category.icon,
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todayExpenses[index].name),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(DateFormat.Hms()
                            .format(todayExpenses[index].dateTime))
                      ],
                    ),
                  ],
                ),
                trailing: Text(
                  "Php ${todayExpenses[index].expense}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}