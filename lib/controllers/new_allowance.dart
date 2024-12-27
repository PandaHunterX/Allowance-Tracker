import 'package:flutter/material.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/categories.dart';
import 'package:productivity_app/models/category.dart';

class NewAllowance extends StatefulWidget {
  const NewAllowance({super.key});

  @override
  State<NewAllowance> createState() => _NewAllowanceState();
}

class _NewAllowanceState extends State<NewAllowance> {
  final _formKey = GlobalKey<FormState>();
  var _enteredDescription = '';
  var _enteredAmount = 0.0;
  var _selectedCategory = allowance_categories[AllowanceCategories.salary]!;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final db = FinanceDB();
      await db.createAllowance(
          description: _enteredDescription,
          amount: _enteredAmount,
          category: _selectedCategory
      );
      print(_enteredAmount);
      print(_enteredDescription);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Allowance'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 50,
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
              onSaved: (value) {
                _enteredDescription = value!;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
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
              onSaved: (value) {
                _enteredAmount = double.parse(value!);
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
    );
  }
}
