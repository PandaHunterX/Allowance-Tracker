import 'package:flutter/material.dart';

import '../database/finance_db.dart';
import '../models/categories.dart';
import '../models/category.dart';

class UpdateExpense extends StatefulWidget {
  final VoidCallback expenseUpdate;
  final String id;
  final String name;
  final double expense;
  final ExpenseCategory category;

  const UpdateExpense({
    super.key,
    required this.id,
    required this.name,
    required this.expense,
    required this.category,
    required this.expenseUpdate,
  });

  @override
  State<UpdateExpense> createState() => _UpdateExpenseState();
}

class _UpdateExpenseState extends State<UpdateExpense> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  late ExpenseCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    nameController.text = widget.name;
    expenseController.text = widget.expense.toString();
  }

  @override
  void dispose() {
    nameController.dispose();
    expenseController.dispose();
    super.dispose();
  }

  void _updateItem() async {
    final db = FinanceDB();
    final fetchUser = await db.fetchUser();
    final fetchedExpenses = await db.fetchExpense();
    double totalAllowance = fetchUser.allowance;
    double totalExpenses =
    fetchedExpenses.fold(0.0, (sum, item) => sum + item.expense);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      double enteredExpense = double.parse(expenseController.text);
      if (widget.expense > enteredExpense) {
        totalAllowance += widget.expense - enteredExpense;
      } else if (widget.expense < enteredExpense) {
        totalAllowance -= enteredExpense - widget.expense;
      }
      if (0 > totalAllowance) {
        showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                title: const Text('Insufficient Allowance'),
                content: const Text("You don't have enough allowance"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Ok'))
                ],
              ),
        );
      } else {
        await db.updateExpense(
            id: widget.id,
            name: nameController.text,
            expense: enteredExpense,
            category: _selectedCategory);
        await db.updateUserAllowance(totalAllowance);
        widget.expenseUpdate();
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change Expense'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              maxLength: 20,
              decoration: const InputDecoration(label: Text('Description')),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value
                        .trim()
                        .length <= 1 ||
                    value
                        .trim()
                        .length > 50) {
                  return 'Must be between 1 and 50 characters';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: expenseController,
              keyboardType: TextInputType.number,
              maxLength: 20,
              decoration: const InputDecoration(label: Text('Expense')),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    double.tryParse(value) == null ||
                    double.tryParse(value)! <= 0) {
                  return 'Must be a positive number';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
                value: _selectedCategory,
                items: [
                  for (final category in expense_categories.entries)
                    DropdownMenuItem(
                        value: category.value,
                        child: Row(
                          children: [
                            category.value.icon,
                            const SizedBox(
                              width: 8,
                            ),
                            Text(category.value.title)
                          ],
                        ))
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                }),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: _updateItem,
                  child: const Text('Update Expense'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
