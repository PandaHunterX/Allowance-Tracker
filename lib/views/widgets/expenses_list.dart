import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/controllers/update_expense.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/expense_item.dart';
import 'package:productivity_app/views/widgets/empty_list.dart';

class ExpensesList extends StatefulWidget {
  final VoidCallback refresh;
  const ExpensesList({super.key, required this.refresh});

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
    final fetchedExpenses = await db.fetchExpense();
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
        ? ExpenseList(todayExpenses: todayExpenses, refresh: widget.refresh,)
        : const ExpenseEmptyList();

    return content;
  }
}

class ExpenseList extends StatelessWidget {
  final VoidCallback refresh;
  const ExpenseList({
    super.key,
    required this.todayExpenses, required this.refresh,
  });

  final List<ExpenseItem> todayExpenses;

  void _deleteItem(BuildContext context, amount, id) async {
    final db = FinanceDB();
    final fetchUser = await db.fetchUser();
    double totalAllowance = fetchUser.allowance;
    totalAllowance += amount;
    await db.deleteExpense(id: id);
    await db.updateUserAllowance(totalAllowance);
    refresh();
    Navigator.of(context).pop();
  }

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
                title: GestureDetector(
                  onLongPress: () =>
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text('Delete Item'),
                            content: SizedBox(
                              width: MediaQuery.sizeOf(context).width - 200,
                              height: MediaQuery.sizeOf(context).height * .3,
                              child: Center(child: Text('Are you sure?')),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(dialogContext)
                                      .pop(); // Dismiss alert dialog
                                },
                              ),
                              ElevatedButton(
                                  onPressed: () => _deleteItem(context, todayExpenses[index].expense, todayExpenses[index].id), child: Text('Yes'))
                            ],
                          );
                        },
                      ),
                  onDoubleTap: () =>
                      showDialog(context: context,
                          builder: (BuildContext context) {
                            return UpdateExpense(
                                id: todayExpenses[index].id,
                                name: todayExpenses[index].name,
                                expense: todayExpenses[index].expense,
                                category: todayExpenses[index].category,
                                expenseUpdate: refresh);
                          }),
                  child: Column(
                    children: [
                      Row(
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
                      const SizedBox(height: 8,),
                      Divider(height: 2, thickness: 2, color: Colors.blue.shade800,)
                    ],
                  ),
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