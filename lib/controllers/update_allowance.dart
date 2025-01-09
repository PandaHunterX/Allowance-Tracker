import 'package:flutter/material.dart';

import '../database/finance_db.dart';
import '../models/categories.dart';
import '../models/category.dart';

class UpdateAllowance extends StatefulWidget {
  final VoidCallback allowanceUpdate;
  final String id;
  final String description;
  final double amount;
  final AllowanceCategory category;

  const UpdateAllowance({
    super.key,
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.allowanceUpdate,
  });

  @override
  State<UpdateAllowance> createState() => _UpdateAllowanceState();
}

class _UpdateAllowanceState extends State<UpdateAllowance> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  late AllowanceCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    descriptionController.text = widget.description;
    amountController.text = widget.amount.toString();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _updateItem() async {
    final db = FinanceDB();
    final fetchUser = await db.fetchUser();
    final fetchedExpenses = await db.fetchExpense();
    double totalAllowance = fetchUser.allowance;
    final totalExpenses =
        fetchedExpenses.fold(0.0, (sum, item) => sum + item.expense);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      double enteredAmount = double.parse(amountController.text);
      if (widget.amount > enteredAmount) {
        totalAllowance -= widget.amount - enteredAmount;
      } else if (widget.amount < enteredAmount) {
        totalAllowance += enteredAmount - widget.amount;
      }
      if (totalExpenses > totalAllowance) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
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
        await db.updateAllowance(
            id: widget.id,
            description: descriptionController.text,
            amount: enteredAmount,
            category: _selectedCategory);
        await db.updateUserAllowance(totalAllowance);
        widget.allowanceUpdate();
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change Allowance'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: descriptionController,
              maxLength: 50,
              decoration: const InputDecoration(label: Text('Description')),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return 'Must be between 1 and 50 characters';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              maxLength: 8,
              decoration: const InputDecoration(label: Text('Amount')),
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
                  for (final category in allowance_categories.entries)
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
                  child: const Text('Update Allowance'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
