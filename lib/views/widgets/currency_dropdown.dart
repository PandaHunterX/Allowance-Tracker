import 'package:flutter/material.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/categories.dart';
import 'package:productivity_app/models/category.dart';

import '../../models/user.dart';

class CurrencyDropdown extends StatefulWidget {
  const CurrencyDropdown({super.key});

  @override
  State<CurrencyDropdown> createState() => _CurrencyDropdownState();
}

class _CurrencyDropdownState extends State<CurrencyDropdown> {
  User? user;
  dynamic _selectedCategory;
  final db = FinanceDB();

  @override
  void initState() {
    super.initState();
    _categoryValue();
  }

  void _saveCurrency() async {
    await db.updateCurrency(_selectedCategory.symbol);
  }

  void _categoryValue() async {
    user = await db.fetchUser();
    if (user != null) {
      for (var entry in currency_categories.entries) {
        if (entry.value.symbol == user!.currency) {
          setState(() {
            _selectedCategory = entry.value;
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropdownButtonFormField<CurrencyCategory>(
        value: _selectedCategory,
        items: currency_categories.entries.map((entry) {
          return DropdownMenuItem<CurrencyCategory>(
            value: entry.value,
            child: Row(
              children: [
                Text(entry.value.symbol),
                const SizedBox(width: 8),
                Text(entry.value.title),
                const SizedBox(width: 8),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value!;
          });
          _saveCurrency();
        },
      ),
    );
  }
}