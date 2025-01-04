import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/expense_item.dart';

class PieGraph extends StatefulWidget {
  const PieGraph({super.key});

  @override
  State<PieGraph> createState() => _PieGraphState();
}

class _PieGraphState extends State<PieGraph> {
  late Future<List<ExpenseItem>> _expenseDataFuture;

  @override
  void initState() {
    super.initState();
    _expenseDataFuture = _loadExpenseData();
  }

  Future<List<ExpenseItem>> _loadExpenseData() async {
    final financeDB = FinanceDB();
    return await financeDB.fetchExpense();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExpenseItem>>(
      future: _expenseDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else {
          final expenseData = snapshot.data!;
          final categoryData = _processData(expenseData);

          return SizedBox(
            height: MediaQuery.of(context).size.height *.5,
            child: PieChart(
              PieChartData(
                sections: _generatePieChartSections(categoryData),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          );
        }
      },
    );
  }

  Map<String, double> _processData(List<ExpenseItem> data) {
    final Map<String, double> categoryData = {};

    for (var item in data) {
      categoryData.update(
        item.category.title,
            (value) => value + item.expense,
        ifAbsent: () => item.expense,
      );
    }

    return categoryData;
  }

  List<PieChartSectionData> _generatePieChartSections(Map<String, double> categoryData) {
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
        return Colors.yellow;
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
      default:
        return Colors.black;
    }
  }
}