import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/models/allowance_item.dart';

import '../../database/finance_db.dart';
import '../../models/expense_item.dart';

class BarGraphScreen extends StatefulWidget {
  const BarGraphScreen({super.key});

  @override
  State<StatefulWidget> createState() => BarGraphScreenState();
}

class BarGraphScreenState extends State<BarGraphScreen> {
  final double width = 15;
  String _selectedType = 'Expense';

  late Future<void> _loadDataFuture;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  double maxValue = 0;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    final financeDB = FinanceDB();
    final data = _selectedType == 'Expense'
        ? (await financeDB.fetchExpense())
        : (await financeDB.fetchAllowance());
    final weeklyData = _selectedType == 'Expense'
        ? _processExpenses(data as List<ExpenseItem>)
        : _processAllowance(data as List<AllowanceItem>);

    setState(() {
      maxValue = weeklyData.reduce((a, b) => a > b ? a : b);
      rawBarGroups = _generateBarGroups(weeklyData);
      showingBarGroups = rawBarGroups;
    });
  }

  List<double> _processExpenses(List<ExpenseItem> expenses) {
    final List<double> weeklyData = List.filled(7, 0.0);

    for (var expense in expenses) {
      final dayOfWeek =
          expense.dateTime.weekday - 1; // Monday is 0, Sunday is 6
      weeklyData[dayOfWeek] += expense.expense;
    }

    return weeklyData;
  }

  List<double> _processAllowance(List<AllowanceItem> allowances) {
    final List<double> weeklyData = List.filled(7, 0.0);

    for (var allowance in allowances) {
      final dayOfWeek =
          allowance.dateTime.weekday - 1; // Monday is 0, Sunday is 6
      weeklyData[dayOfWeek] += allowance.amount;
    }

    return weeklyData;
  }

  List<BarChartGroupData> _generateBarGroups(List<double> weeklyExpenses) {
    return List.generate(7, (index) {
      return makeGroupData(index, weeklyExpenses[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (maxValue == 0) {
      return Center(
        child: Text("You have no data"),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<void>(
            future: _loadDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading data'));
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          width: 38,
                        ),
                        const Text(
                          'Weekly Data',
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RadioListTile(
                            title: const Text('Expense'),
                            selected: true,
                            value: 'Expense',
                            groupValue: _selectedType,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value!;
                                _loadDataFuture = _loadData();
                              });
                            }),
                        RadioListTile(
                            title: const Text('Allowance'),
                            value: 'Allowance',
                            groupValue: _selectedType,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value!;
                                _loadDataFuture = _loadData();
                              });
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          maxY: maxValue,
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: bottomTitlesDays,
                                reservedSize: 42,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                          ),
                          barGroups: showingBarGroups,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      );
    }
  }

  Widget bottomTitlesDays(double value, TitleMeta meta) {
    final titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, // Margin top
      child: Text(
        titles[value.toInt()],
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: _selectedType == 'Expense' ? Colors.red : Colors.blue,
          width: width,
        ),
      ],
    );
  }
}
