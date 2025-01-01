import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../database/finance_db.dart';
import '../../models/expense_item.dart';

class GraphScreen extends StatefulWidget {
  GraphScreen({super.key});

  final Color leftBarColor = Colors.blue;
  final Color rightBarColor = Colors.red;
  final Color avgColor = Colors.orange;

  @override
  State<StatefulWidget> createState() => GraphScreenState();
}

class GraphScreenState extends State<GraphScreen> {
  final double width = 15;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  double maxExpense = 0;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final financeDB = FinanceDB();
    final expenses = await financeDB.fetchExpense();
    final weeklyExpenses = _processExpenses(expenses);

    setState(() {
      maxExpense = weeklyExpenses.reduce((a, b) => a > b ? a : b);
      rawBarGroups = _generateBarGroups(weeklyExpenses);
      showingBarGroups = rawBarGroups;
    });
  }

  List<double> _processExpenses(List<ExpenseItem> expenses) {
    final List<double> weeklyExpenses = List.filled(7, 0.0);

    for (var expense in expenses) {
      final dayOfWeek = expense.dateTime.weekday - 1; // Monday is 0, Sunday is 6
      weeklyExpenses[dayOfWeek] += expense.expense;
    }

    return weeklyExpenses;
  }

  List<BarChartGroupData> _generateBarGroups(List<double> weeklyExpenses) {
    return List.generate(7, (index) {
      return makeGroupData(index, weeklyExpenses[index], 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                makeTransactionsIcon(),
                const SizedBox(
                  width: 38,
                ),
                const Text(
                  'Weekly Expenses',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ],
            ),
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: maxExpense, // Adjusted for better scaling
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String day;
                        switch (group.x.toInt()) {
                          case 0:
                            day = 'Mon';
                            break;
                          case 1:
                            day = 'Tue';
                            break;
                          case 2:
                            day = 'Wed';
                            break;
                          case 3:
                            day = 'Thu';
                            break;
                          case 4:
                            day = 'Fri';
                            break;
                          case 5:
                            day = 'Sat';
                            break;
                          case 6:
                            day = 'Sun';
                            break;
                          default:
                            day = '';
                        }
                        return BarTooltipItem(
                          '$day\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: (rod.toY).toString(),
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: (maxExpense / 5).ceilToDouble(), // Adjusted interval for better scaling
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = '${(value / 1000).round()}K';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, // Margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.black.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.black.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.black,
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.black.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.black.withOpacity(0.4),
        ),
      ],
    );
  }
}
