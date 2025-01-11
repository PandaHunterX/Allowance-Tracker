import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/controllers/update_expense.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/expense_item.dart';
import 'package:productivity_app/styles/textstyle.dart';
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
  dynamic user;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    final db = FinanceDB();
    final fetchedExpenses = await db.fetchExpense();
    final fetchedUser = await db.fetchUser();
    setState(() {
      expenses = fetchedExpenses;
      user = fetchedUser;
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
        ? ExpenseList(
            todayExpenses: todayExpenses,
            refresh: widget.refresh,
            user: user,
          )
        : const ExpenseEmptyList();

    return content;
  }
}

class ExpenseList extends StatelessWidget {
  final VoidCallback refresh;
  final dynamic user;

  const ExpenseList({
    super.key,
    required this.user,
    required this.todayExpenses,
    required this.refresh,
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
          TitleText(
              words:
                  "Total Expenses: ${user.currency} ${todayExpenses.fold(0.0, (sum, item) => sum + item.expense)}",
              size: 32,
              fontWeight: FontWeight.w500),
          Expanded(
            child: ListView.builder(
              itemCount: todayExpenses.length,
              itemBuilder: (ctx, index) => ListTile(
                  title: GestureDetector(
                    onLongPress: () => showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text(
                            'DELETE ITEM',
                            textAlign: TextAlign.center,
                          ),
                          content: SizedBox(
                            width: MediaQuery.sizeOf(context).width - 200,
                            height: 300,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/delete-item.png',
                                    width: 250,
                                  ),
                                  SizedBox(height: 8,),
                                  Expanded(
                                      child: SecondaryText(
                                    words:
                                        'Are you sure you want to delete ${todayExpenses[index].name}?',
                                    size: 24,
                                    maxLines: 2,
                                  )),
                                ],
                              ),
                            ),
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
                                onPressed: () => _deleteItem(
                                    context,
                                    todayExpenses[index].expense,
                                    todayExpenses[index].id),
                                child: Text('Yes'))
                          ],
                        );
                      },
                    ),
                    onDoubleTap: () => showDialog(
                        context: context,
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
                            Icon(todayExpenses[index].category.icon.icon,
                                size: 32.0),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .45,
                                  child: TitleText(
                                      words: todayExpenses[index].name,
                                      size: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                SecondaryText(
                                    words: DateFormat.Hms()
                                        .format(todayExpenses[index].dateTime),
                                    size: 16,
                                    maxLines: 1),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Divider(
                          height: 2,
                          thickness: 2,
                          color: Colors.blue.shade800,
                        )
                      ],
                    ),
                  ),
                  trailing: TitleText(
                      words: "${user.currency} ${todayExpenses[index].expense}",
                      size: 24,
                      fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}
