import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/expense_item.dart';
import 'package:productivity_app/models/allowance_item.dart';

import '../../models/categories.dart';
import '../../models/category.dart';

class PieGraph extends StatefulWidget {
  const PieGraph({super.key});

  @override
  State<PieGraph> createState() => _PieGraphState();
}

class _PieGraphState extends State<PieGraph> {
  late Future<List<dynamic>> _dataFuture;
  String _selectedType = 'Expense';

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<List<dynamic>> _loadData() async {
    final financeDB = FinanceDB();
    if (_selectedType == 'Expense') {
      return await financeDB.fetchExpense();
    } else {
      return await financeDB.fetchAllowance();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Your Category Data'),
        SizedBox(height: 16,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: RadioListTile(
                tileColor: Colors.blue.shade100,
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                activeColor: Colors.blue.shade900,
                title: const Text('Expense'),
                value: 'Expense',
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    _dataFuture = _loadData();
                  });
                },
              ),
            ),
            SizedBox(width: 8,),
            SizedBox(
              width: 200,
              child: RadioListTile(
                tileColor: Colors.blue.shade100,
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                activeColor: Colors.blue.shade900,
                title: const Text('Allowance'),
                value: 'Allowance',
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    _dataFuture = _loadData();
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16,),
        FutureBuilder<List<dynamic>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            } else {
              final data = snapshot.data!;
              if (data.isEmpty) {
                return const Center(child: Text('No data available'));
              }
              final categoryData = _processData(data);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blue.shade900, width: 4)
                      ),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .2,
                      child: PieChart(
                        PieChartData(
                          sections: _generatePieChartSections(categoryData),
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                  ),
                  _buildLegend(categoryData),
                  const SizedBox(height: 16),
                ],
              );
            }
          },
        )
      ],
    );
  }

  Map<String, double> _processData(List<dynamic> data) {
    final Map<String, double> categoryData = {};

    for (var item in data) {
      final category = _selectedType == 'Expense'
          ? (item as ExpenseItem).category.title
          : (item as AllowanceItem).category.title;
      final amount = _selectedType == 'Expense'
          ? (item as ExpenseItem).expense
          : (item as AllowanceItem).amount;

      categoryData.update(
        category,
            (value) => value + amount,
        ifAbsent: () => amount,
      );
    }

    return categoryData;
  }

  List<PieChartSectionData> _generatePieChartSections(
      Map<String, double> categoryData) {
    final List<PieChartSectionData> sections = [];
    final total = categoryData.values.reduce((a, b) => a + b);

    categoryData.forEach((category, amount) {
      final percentage = (amount / total) * 100;
      sections.add(
        PieChartSectionData(
          color: _getCategoryColor(category),
          value: percentage,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return sections;
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.red;
      case 'Entertainment':
        return Colors.blue;
      case 'Transportation':
        return Colors.green;
      case 'Education':
        return Colors.yellow.shade900;
      case 'Health':
        return Colors.purple;
      case 'Shopping':
        return Colors.orange;
      case 'Subscriptions':
        return Colors.cyan;
      case 'Utilities':
        return Colors.brown;
      case 'Donations':
        return Colors.pink;
      case 'Others':
        return Colors.grey;
      case 'Salary':
        return Colors.teal;
      case 'Gifts':
        return Colors.amber;
      case 'Scholarship':
        return Colors.indigo;
      case 'Business':
        return Colors.lime;
      case 'Family Support':
        return Colors.lightBlue;
      case 'Government Aid':
        return Colors.deepOrange;
      default:
        return Colors.black;
    }
  }

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return expense_categories[ExpenseCategories.food]!.icon;
      case 'Entertainment':
        return expense_categories[ExpenseCategories.entertainment]!.icon;
      case 'Transportation':
        return expense_categories[ExpenseCategories.transportation]!.icon;
      case 'Education':
        return expense_categories[ExpenseCategories.education]!.icon;
      case 'Health':
        return expense_categories[ExpenseCategories.health]!.icon;
      case 'Shopping':
        return expense_categories[ExpenseCategories.shopping]!.icon;
      case 'Subscriptions':
        return expense_categories[ExpenseCategories.subscriptions]!.icon;
      case 'Utilities':
        return expense_categories[ExpenseCategories.utilities]!.icon;
      case 'Donations':
        return expense_categories[ExpenseCategories.donations]!.icon;
      case 'Others':
        return expense_categories[ExpenseCategories.others]!.icon;
      case 'Salary':
        return allowance_categories[AllowanceCategories.salary]!.icon;
      case 'Gifts':
        return allowance_categories[AllowanceCategories.gifts]!.icon;
      case 'Scholarship':
        return allowance_categories[AllowanceCategories.scholarship]!.icon;
      case 'Business':
        return allowance_categories[AllowanceCategories.businessProfit]!.icon;
      case 'Family Support':
        return allowance_categories[AllowanceCategories.familySupport]!.icon;
      case 'Government Aid':
        return allowance_categories[AllowanceCategories.governmentAid]!.icon;
      default:
        return const Icon(Icons.help, color: Colors.black);
    }
  }

  Widget _buildLegend(Map<String, double> categoryData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text('Legend'),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 4.5,
            ),
            itemCount: categoryData.keys.length,
            itemBuilder: (context, index) {
              final category = categoryData.keys.elementAt(index);
              final icon = _getCategoryIcon(category);
              final color = _getCategoryColor(category);
              final totalAmount = categoryData[category]!;
              return Container(
                decoration: BoxDecoration(border: Border.all(color: color, width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon,
                    SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category,
                            style: TextStyle(color: color),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('Php ${totalAmount.toStringAsFixed(2)}', style: TextStyle(color: color),
                            overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}