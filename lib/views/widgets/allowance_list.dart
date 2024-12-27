import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/allowance_item.dart';

class AllowancesList extends StatefulWidget {
  const AllowancesList({super.key});

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

    var content = (allowances.isNotEmpty) ? AllowanceList(allowances: allowances,) : const Text('data');

    return content;
  }
}

class AllowanceList extends StatelessWidget {
  const AllowanceList({super.key, required this.allowances});

  final List<AllowanceItem> allowances;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allowances.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Column(
                  children: [
                    Row(
                      children: [
                        allowances[index].category.icon,
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(allowances[index].description),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(DateFormat.Hms()
                                .format(allowances[index].dateTime))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Divider(height: 2, thickness: 2, color: Colors.blue.shade800,)
                  ],
                ),
                trailing: Text(
                  "Php ${allowances[index].amount}",
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

