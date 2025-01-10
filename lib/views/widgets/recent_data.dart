import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/allowance_item.dart';
import 'package:productivity_app/models/expense_item.dart';
import 'package:intl/intl.dart';

class RecentDataList extends StatefulWidget {
  final String searchQuery;

  const RecentDataList({super.key, required this.searchQuery});

  @override
  State<RecentDataList> createState() => _RecentDataListState();
}

class _RecentDataListState extends State<RecentDataList> {
  List<dynamic> recentData = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
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

    setState(() {
      recentData = [...fetchedAllowances, ...fetchedExpenses];
      recentData.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      _isLoading = false;
    });
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate fetching more data
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

    final paginatedData =
        filteredData.take(_currentPage * _itemsPerPage).toList();

    return ListView.builder(
      controller: _scrollController,
      itemCount: paginatedData.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (ctx, index) {
        if (index == paginatedData.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final item = paginatedData[index];
        if (item is AllowanceItem) {
          return ListTile(
            textColor: Colors.green.shade900,
            title: Row(
              children: [
                item.category.icon,
                SizedBox(
                  width: 4,
                ),
                Expanded(child: AutoSizeText(maxLines: 1, 'Allowance: ${item.description}')),
              ],
            ),
            subtitle: Text('Amount: ++ Php ${item.amount}'),
            trailing: Text(DateFormat.yMMMd().format(item.dateTime)),
          );
        } else if (item is ExpenseItem) {
          return ListTile(
            textColor: Colors.red.shade900,
            title: Row(
              children: [
                item.category.icon,
                SizedBox(
                  width: 4,
                ),
                Text('Expense: ${item.name}'),
              ],
            ),
            subtitle: Text('Amount: -- Php ${item.expense}'),
            trailing: Text(DateFormat.yMMMd().format(item.dateTime)),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
