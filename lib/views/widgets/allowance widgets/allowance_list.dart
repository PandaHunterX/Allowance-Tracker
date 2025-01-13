import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/controllers/data%20controller/delete_item.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/item%20model/allowance_item.dart';
import 'package:productivity_app/styles/text_style.dart';
import 'package:productivity_app/views/widgets/data%20widgets/empty_list.dart';
import 'package:productivity_app/views/widgets/data%20widgets/insufficient_allowance.dart';
import 'package:productivity_app/views/widgets/user%20widgets/user_allowance.dart';
import '../../../controllers/allowance controllers/update_allowance.dart';

class AllowancesList extends StatefulWidget {
  final VoidCallback refresh;

  const AllowancesList({super.key, required this.refresh});

  @override
  State<AllowancesList> createState() => _AllowancesListState();
}

class _AllowancesListState extends State<AllowancesList> {
  List<AllowanceItem> allowances = [];
  dynamic user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllowances();
  }

  Future<void> _fetchAllowances() async {
    final db = FinanceDB();
    final fetchedAllowances = await db.fetchAllowance();
    final fetchUser = await db.fetchUser();
    setState(() {
      allowances = fetchedAllowances;
      user = fetchUser;
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
            user: user,
          )
        : const AllowanceEmptyList();

    return content;
  }
}

class AllowanceList extends StatelessWidget {
  final VoidCallback refresh;
  final dynamic user;

  const AllowanceList({
    super.key,
    required this.allowances,
    required this.refresh,
    required this.user,
  });

  final List<AllowanceItem> allowances;

  void _deleteItem(BuildContext context, amount, id) async {
    final db = FinanceDB();
    final fetchUser = await db.fetchUser();
    double totalAllowance = fetchUser.allowance;
    totalAllowance -= amount;
    if (0 > totalAllowance) {
      if (context.mounted) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (ctx) => InsufficientAllowance(ctx: ctx));
      }
    } else {
      await db.deleteAllowance(id: id);
      await db.updateUserAllowance(totalAllowance);
      refresh();
      if (context.mounted) {
        Navigator.of(context).pop();
      }
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
              TitleText(
                  words: 'Remaining Allowance:  ',
                  size: 24,
                  fontWeight: FontWeight.w800),
              UserAllowance(),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            height: 4,
            color: Colors.blue.shade800,
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  recentAllowances.length < 3 ? recentAllowances.length : 3,
              itemBuilder: (ctx, index) => GestureDetector(
                onLongPress: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return DeleteItem(
                        item: recentAllowances[index].description,
                        delete: () => _deleteItem(
                            context,
                            recentAllowances[index].amount,
                            recentAllowances[index].id),
                        context: dialogContext);
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
                child: ListTile(
                  title: Column(
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
                              TitleText(
                                  words: recentAllowances[index].description,
                                  size: 20,
                                  fontWeight: FontWeight.w500),
                              const SizedBox(
                                width: 4,
                              ),
                              SecondaryText(
                                words: DateFormat.yMMMd()
                                    .format(recentAllowances[index].dateTime),
                                size: 16,
                                maxLines: 1,
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.blue.shade600,
                      )
                    ],
                  ),
                  trailing: Wrap(
                    children: [
                      Text(
                        '${user.currency} ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TitleText(
                        words: "${recentAllowances[index].amount}",
                        size: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
