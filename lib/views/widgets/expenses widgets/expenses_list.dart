import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/controllers/expense%20controllers/update_expense.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/item%20model/expense_item.dart';
import 'package:productivity_app/styles/text_style.dart';
import 'package:productivity_app/views/widgets/data%20widgets/empty_list.dart';

import '../../../controllers/data controller/delete_item.dart';

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
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleText(
                  words: "Total Expenses: ",
                  size: 24,
                  fontWeight: FontWeight.w500),
              Text(
                '${user.currency} ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SecondaryText(
                  words:
                      '${todayExpenses.fold(0.0, (sum, item) => sum + item.expense)}',
                  size: 24,
                  maxLines: 1)
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todayExpenses.length,
              itemBuilder: (ctx, index) => GestureDetector(
                  onLongPress: () => showDialog<void>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return DeleteItem(
                            item: todayExpenses[index].name,
                            delete: () => _deleteItem(
                                context,
                                todayExpenses[index].expense,
                                todayExpenses[index].id),
                            context: dialogContext,
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
                  child: ListTile(
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Icon(todayExpenses[index].category.icon.icon,
                                size: 32.0),
                            const SizedBox(width: 8),
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
                                const SizedBox(width: 4),
                                SecondaryText(
                                    words: DateFormat.Hms()
                                        .format(todayExpenses[index].dateTime),
                                    size: 16,
                                    maxLines: 1),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(
                          height: 2,
                          thickness: 2,
                          color: Colors.blue.shade800,
                        )
                      ],
                    ),
                    trailing: Wrap(
                      children: [
                        Text(
                          '${user.currency} ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TitleText(
                            words: "${todayExpenses[index].expense}",
                            size: 16,
                            fontWeight: FontWeight.w900),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
