import 'package:flutter/material.dart';
import 'package:productivity_app/models/categories.dart';
import 'package:productivity_app/database/finance_db.dart';
import '../models/category.dart';

class NewExpense extends StatefulWidget {
  final VoidCallback onExpenseAdded;

  const NewExpense({super.key, required this.onExpenseAdded});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredExpense = 0.0;
  var _selectedCategory = expense_categories[ExpenseCategories.food]!;

  void _saveItem() async {
    final db = FinanceDB();
    final fetchUser = await db.fetchUser();
    var user = fetchUser;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (user.allowance < _enteredExpense) {
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
        await db.createExpenses(
          name: _enteredName,
          expense: _enteredExpense,
          category: _selectedCategory,
        );
        await db.updateAllowance(user.allowance - _enteredExpense);
        widget.onExpenseAdded();
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
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
                      onSaved: (value) {
                        _enteredExpense = double.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in expense_categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(children: [
                              category.value.icon,
                              const SizedBox(
                                width: 8,
                              ),
                              Text(category.value.title)
                            ]),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Clear')),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add Expense'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
