// lib/views/widgets/recent_data.dart
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/controllers/delete_item.dart';
import 'package:productivity_app/controllers/update_allowance.dart';
import 'package:productivity_app/controllers/update_expense.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/allowance_item.dart';
import 'package:productivity_app/models/expense_item.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/models/user.dart';
import 'package:productivity_app/styles/textstyle.dart';

import 'empty_data.dart';
import 'insufficient_allowance.dart';

class RecentDataList extends StatefulWidget {
  final String searchQuery;
  final String selectedMonth;

  const RecentDataList({super.key, required this.searchQuery, required this.selectedMonth});

  @override
  State<RecentDataList> createState() => _RecentDataListState();
}

class _RecentDataListState extends State<RecentDataList> {
  List<dynamic> recentData = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  User? user;
  final int _itemsPerPage = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchRecentData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecentData() async {
    final db = FinanceDB();
    final fetchedAllowances = await db.fetchAllowance();
    final fetchedExpenses = await db.fetchExpense();
    var fetchedUser = await db.fetchUser();

    setState(() {
      recentData = [...fetchedAllowances, ...fetchedExpenses];
      recentData.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      _isLoading = false;
      user = fetchedUser;
    });
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _currentPage++;
      _isLoadingMore = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  void _refreshed() {
    setState(() {
      _isLoading = true;
    });
    _fetchRecentData();
  }

  void _deleteExpenseItem(BuildContext context, amount, id) async {
    final db = FinanceDB();
    final fetchUser = await db.fetchUser();
    double totalAllowance = fetchUser.allowance;
    totalAllowance += amount;
    await db.deleteExpense(id: id);
    await db.updateUserAllowance(totalAllowance);
    _refreshed();
    Navigator.of(context).pop();
  }

  void _deleteAllowanceItem(BuildContext context, amount, id) async {
    final db = FinanceDB();
    final fetchUser = await db.fetchUser();
    double totalAllowance = fetchUser.allowance;
    totalAllowance -= amount;
    if (0 > totalAllowance) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (ctx) => InsufficientAllowance(ctx: ctx)
      );
    } else {
      await db.deleteAllowance(id: id);
      await db.updateUserAllowance(totalAllowance);
      _refreshed();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredData = recentData.where((item) {
      if (item is AllowanceItem) {
        return item.description.contains(widget.searchQuery);
      } else if (item is ExpenseItem) {
        return item.name.contains(widget.searchQuery);
      }
      return false;
    }).toList();

    final filteredByMonth = filteredData.where((item) {
      if (widget.selectedMonth != 'All') {
        int month = DateFormat.MMMM().parse(widget.selectedMonth).month;
        return item.dateTime.month == month;
      }
      return true;
    }).toList();

    final paginatedData =
    filteredByMonth.take(_currentPage * _itemsPerPage).toList();

    if (paginatedData.isEmpty) {
      return const Center(
        child: EmptyData(),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: paginatedData.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (ctx, index) {
        if (index == paginatedData.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final item = paginatedData[index];
        if (item is AllowanceItem) {
          return GestureDetector(
            onDoubleTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return UpdateAllowance(
                    id: item.id,
                    description: item.description,
                    amount: item.amount,
                    category: item.category,
                    allowanceUpdate: _refreshed,
                  );
                }),
            onLongPress: () => showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return DeleteItem(item: item.description, delete: () => _deleteAllowanceItem(context, item.amount, item.id), context: dialogContext);
                }
            ),
            child: ListTile(
              textColor: Colors.green.shade900,
              title: Row(
                children: [
                  item.category.icon,
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                      child: TitleText(
                          words: 'Allowance: ${item.description}',
                          size: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              subtitle: Row(
                children: [
                  SecondaryText(words: 'Amount: ', size: 16, maxLines: 1),
                  AutoSizeText(
                    "++ ${user?.currency}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SecondaryText(words: '${item.amount}', size: 16, maxLines: 1),
                ],
              ),
              trailing: TitleText(
                  words: DateFormat.yMMMd().format(item.dateTime),
                  size: 16,
                  fontWeight: FontWeight.w600),
            ),
          );
        } else if (item is ExpenseItem) {
          return GestureDetector(
            onDoubleTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return UpdateExpense(
                      id: item.id,
                      name: item.name,
                      expense: item.expense,
                      category: item.category,
                      expenseUpdate: _refreshed);
                }),
            onLongPress: () => showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return DeleteItem(
                      item: item.name,
                      delete: () => _deleteExpenseItem(context, item.expense, item.id),
                      context: dialogContext);
                }),
            child: ListTile(
              textColor: Colors.redAccent,
              title: Row(
                children: [
                  item.category.icon,
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                      child: TitleText(
                          words: 'Expense: ${item.name}',
                          size: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              subtitle: Row(
                children: [
                  SecondaryText(words: 'Amount: ', size: 16, maxLines: 1),
                  AutoSizeText(
                    "-- ${user?.currency}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SecondaryText(
                      words: '${item.expense}', size: 16, maxLines: 1),
                ],
              ),
              trailing: TitleText(
                  words: DateFormat.yMMMd().format(item.dateTime),
                  size: 16,
                  fontWeight: FontWeight.w600),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}