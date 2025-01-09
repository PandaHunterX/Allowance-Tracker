import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/allowance_item.dart';
import 'package:productivity_app/views/widgets/empty_list.dart';
import 'package:productivity_app/views/widgets/user_allowance.dart';
import '../../controllers/update_allowance.dart';

class AllowancesList extends StatefulWidget {
  final VoidCallback refresh;

  const AllowancesList({super.key, required this.refresh});

  @override
  State<AllowancesList> createState() => _AllowancesListState();
}

class _AllowancesListState extends State<AllowancesList> {
  List<AllowanceItem> allowances = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllowances();
  }

  Future<void> _fetchAllowances() async {
    final db = FinanceDB();
    final fetchedAllowances = await db.fetchAllowance();
    setState(() {
      allowances = fetchedAllowances;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    var content = (allowances.isNotEmpty)
        ? AllowanceList(
            allowances: allowances,
            refresh: widget.refresh,
          )
        : const AllowanceEmptyList();

    return content;
  }
}

class AllowanceList extends StatelessWidget {
  final VoidCallback refresh;

  const AllowanceList(
      {super.key, required this.allowances, required this.refresh});

  final List<AllowanceItem> allowances;

  void _deleteItem(BuildContext context, amount, id) async {
    final db = FinanceDB();
    final fetchUser = await db.fetchUser();
    final fetchedExpenses = await db.fetchExpense();
    double totalAllowance = fetchUser.allowance;
    totalAllowance -= amount;
    if (0 > totalAllowance) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: const Text('Insufficient Allowance'),
              content: const Text("You don't have enough allowance"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Ok'))
              ],
            ),
      );
    }
    else {
      await db.deleteAllowance(id: id);
      await db.updateUserAllowance(totalAllowance);
      refresh();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentAllowances = allowances.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your Allowance: '),
              UserAllowance(),
            ],
          ),
          Divider(height: 4, color: Colors.blue.shade800,),
          Expanded(
            child: ListView.builder(
              itemCount:
                  recentAllowances.length < 3 ? recentAllowances.length : 3,
              itemBuilder: (ctx, index) => ListTile(
                title: GestureDetector(
                  onLongPress: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: Text('Delete Item'),
                        content: SizedBox(
                          width: MediaQuery.sizeOf(context).width - 200,
                          height: MediaQuery.sizeOf(context).height * .3,
                          child: Center(child: Text('Are you sure?')),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(dialogContext)
                                  .pop(); // Dismiss alert dialog
                            },
                          ),
                          ElevatedButton(
                              onPressed: () => _deleteItem(context, recentAllowances[index].amount, recentAllowances[index].id), child: Text('Yes'))
                        ],
                      );
                    },
                  ),
                  onDoubleTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UpdateAllowance(
                          id: recentAllowances[index].id,
                          description: recentAllowances[index].description,
                          amount: recentAllowances[index].amount,
                          category: recentAllowances[index].category,
                          allowanceUpdate: refresh,
                        );
                      }),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          recentAllowances[index].category.icon,
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(recentAllowances[index].description),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(DateFormat.yMMMd()
                                  .format(recentAllowances[index].dateTime))
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Divider(height: 1, color: Colors.blue.shade600,)
                    ],
                  ),
                ),
                trailing: Text(
                  "Php ${recentAllowances[index].amount}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
