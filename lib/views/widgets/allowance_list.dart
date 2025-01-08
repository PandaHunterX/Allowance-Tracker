import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/allowance_item.dart';
import 'package:productivity_app/views/widgets/empty_list.dart';

import '../../controllers/update_allowance.dart';
import '../../database/database_service.dart';

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

    var content = (allowances.isNotEmpty) ? AllowanceList(
      allowances: allowances, refresh: widget.refresh,) : const AllowanceEmptyList();

    return content;
  }
}

class AllowanceList extends StatelessWidget {
  final VoidCallback refresh;
  const AllowanceList({super.key, required this.allowances, required this.refresh});

  final List<AllowanceItem> allowances;


  @override
  Widget build(BuildContext context) {
    final recentAllowances = allowances.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: recentAllowances.length < 3
                  ? recentAllowances.length
                  : 3,
              itemBuilder: (ctx, index) =>
                  ListTile(
                    title: GestureDetector(
                      onDoubleTap: () async {
                        print(recentAllowances[index].description);
                        print(recentAllowances[index].id);
                        final database = await DatabaseService().database;
                        final List<Map<String, dynamic>> allowanceRecords = await database.query('allowances');
                        print("All Allowances: $allowanceRecords");
                      },
                      onTap: () =>
                          showDialog(context: context,
                              builder: (BuildContext context) {
                                return UpdateAllowance(
                                  id: recentAllowances[index].id,
                                  description: recentAllowances[index].description,
                                  amount: recentAllowances[index].amount,
                                  category: recentAllowances[index].category, allowanceUpdate: refresh,
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
                          const SizedBox(height: 8,),
                          Divider(height: 2,
                            thickness: 2,
                            color: Colors.blue.shade800,)
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



